# frozen_string_literal: true

require 'spec_helper'
describe 'zram_generator' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults for all parameters' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('zram_generator::install') }
        it { is_expected.to contain_class('zram_generator::config') }
        it { is_expected.to contain_class('zram_generator::service') }
        it { is_expected.to contain_exec('generate_zram_units').with_refreshonly(true) }
        it { is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d').with_ensure('directory') }
        it { is_expected.to contain_package('zram-generator-defaults').with_ensure('absent') }
        it { is_expected.to contain_package('zram-generator').with_ensure('installed') }

        context 'with install_defaults absent' do
          let(:params) do
            { install_defaults: 'absent' }
          end

          it { is_expected.to contain_package('zram-generator-defaults').with_ensure('absent') }
        end

        context 'with install_defaults installed' do
          let(:params) do
            { install_defaults: 'installed' }
          end

          it { is_expected.to contain_package('zram-generator-defaults').with_ensure('installed') }
        end
      end
    end
  end
end
