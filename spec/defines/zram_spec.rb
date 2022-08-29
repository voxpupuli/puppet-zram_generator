# frozen_string_literal: true

require 'spec_helper'

describe 'zram_generator::zram' do
  on_supported_os.each do |os, facts|
    let(:title) { 'zram0' }
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('zram_generator') }
      it { is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').with_ensure('file') }

      it {
        is_expected.to contain_service('dev-zram0.swap').with(
          {
            ensure: true,
            enable: true,
          }
        )
      }

      it {
        is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').
          with_content(%r{^\[zram0\]})
      }

      it {
        is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').
          with_content(%r{^host-memory-limit\s+=\snone$})
      }

      it {
        is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').
          with_content(%r{^zram-size\s+=\smin\(ram / 2, 4096\)$})
      }

      it {
        is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').
          with_content(%r{^swap-priority\s+=\s100$})
      }

      it {
        is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').
          with_content(%r{^options\s+=\sdiscard$})
      }

      it {
        is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').
          without_content(%r{compression-algorithm})
      }

      it {
        is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').
          without_content(%r{mount-point})
      }

      it {
        is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').
          without_content(%r{fs-type})
      }

      it {
        is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').
          without_content(%r{writeback-device})
      }

      context 'with ensure present' do
        let(:params) do
          { ensure: 'present' }
        end

        it { is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').with_ensure('file') }

        it {
          is_expected.to contain_service('dev-zram0.swap').with(
            {
              ensure: true,
              enable: true,
            }
          )
        }
      end

      context 'with ensure absent' do
        let(:params) do
          { ensure: 'absent' }
        end

        it { is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram0.conf').with_ensure('absent') }

        it {
          is_expected.to contain_service('dev-zram0.swap').with(
            {
              ensure: false,
              enable: false,
            }
          )
        }
      end

      context 'with all config parameters set' do
        let(:params) do
          {
            device: 'zram1',
            host_memory_limit: 1000,
            zram_size: 2000,
            compression_algorithm: 'special',
            writeback_device: '/dev/my/write/back',
            swap_priority: 2000,
            mount_point: '/foo/bar',
            fs_type: 'ext1000',
            options: 'special ones',
          }
        end

        it {
          is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram1.conf').
            with_content(%r{^\[zram1\]})
        }

        it {
          is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram1.conf').
            with_content(%r{^host-memory-limit\s+=\s1000$})
        }

        it {
          is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram1.conf').
            with_content(%r{^zram-size\s+=\s2000$})
        }

        it {
          is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram1.conf').
            with_content(%r{^swap-priority\s+=\s2000$})
        }

        it {
          is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram1.conf').
            with_content(%r{^options\s+=\sspecial ones$})
        }

        it {
          is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram1.conf').
            with_content(%r{^compression-algorithm\s+=\s+special$})
        }

        it {
          is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram1.conf').
            with_content(%r{^mount-point\s+=\s+/foo/bar$})
        }

        it {
          is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram1.conf').
            with_content(%r{^fs-type\s+=\s+ext1000$})
        }

        it {
          is_expected.to contain_file('/usr/lib/systemd/zram-generator.conf.d/zram1.conf').
            with_content(%r{^writeback-device\s+=\s+/dev/my/write/back$})
        }
      end
    end
  end
end
