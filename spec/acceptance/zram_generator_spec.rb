# frozen_string_literal: true

require 'spec_helper_acceptance'

# EL8 base repos don't ship zram-generator
describe 'zram_generator', unless: fact('os.family') == 'RedHat' && fact('os.release.major') == '8' do
  context 'with default parameters' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          include zram_generator
        PUPPET
      end
    end

    describe package((fact('os.family') == 'Debian') ? 'systemd-zram-generator' : 'zram-generator') do
      it { is_expected.to be_installed }
    end

    describe file('/usr/lib/systemd/zram-generator.conf.d') do
      it { is_expected.to be_directory }
    end
  end

  context 'with a zram device' do
    # containers can't create zram devices, so starting dev-zram0.swap fails
    it 'applies with errors' do
      apply_manifest(<<~PUPPET, expect_failures: true)
        zram_generator::zram { 'zram0':
          zram_size => 'ram / 2',
        }
      PUPPET
    end

    describe file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match %r{^\[zram0\]$} }
      its(:content) { is_expected.to match %r{^zram-size\s+= ram / 2$} }
      its(:content) { is_expected.to match %r{^swap-priority\s+= 100$} }
    end
  end

  context 'with a zram device removed' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          zram_generator::zram { 'zram0':
            ensure => absent,
          }
        PUPPET
      end
    end

    describe file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf') do
      it { is_expected.not_to exist }
    end
  end
end
