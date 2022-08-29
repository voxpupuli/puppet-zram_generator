# @summary Install and configure zram_generator zram mounts
# @see https://github.com/systemd/zram-generator
# @param install_defaults Controls if the package 'zram-generator-defaults' be installed.
#
class zram_generator (
  Enum['installed', 'absent'] $install_defaults = 'absent',
) {
  contain zram_generator::install
  contain zram_generator::config
  contain zram_generator::service

  Class['zram_generator::install']
  -> Class['zram_generator::config']
  -> Class['zram_generator::service']
}
