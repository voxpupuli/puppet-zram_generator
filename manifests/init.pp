# @summary Install and configure zram_generator zram mounts
# @see https://github.com/systemd/zram-generator
# @param install_defaults Controls if the package 'zram-generator-defaults' be installed.
# @param manage_defaults_package whether the zram-generator-defaults package should be managed
#
class zram_generator (
  Enum['installed', 'absent'] $install_defaults = 'absent',
  Boolean $manage_defaults_package = $facts['os']['name'] != 'Archlinux',
) {
  contain zram_generator::install
  contain zram_generator::config
  contain zram_generator::service

  Class['zram_generator::install']
  -> Class['zram_generator::config']
  -> Class['zram_generator::service']
}
