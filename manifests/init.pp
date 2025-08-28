# @summary Install and configure zram_generator zram mounts
# @see https://github.com/systemd/zram-generator
# @param install_defaults Controls if the package 'zram-generator-defaults' be installed.
# @param manage_defaults_package whether the zram-generator-defaults package should be managed
# @param zrams Hash of zram_generator::zram instances to expand from hiera.
#
class zram_generator (
  String[1] $package_name,
  Enum['installed', 'absent'] $install_defaults = 'absent',
  Boolean $manage_defaults_package = $facts['os']['name'] != 'Archlinux',
  Stdlib::CreateResources $zrams = {},
) {
  contain zram_generator::install
  contain zram_generator::config
  contain zram_generator::service

  Class['zram_generator::install']
  -> Class['zram_generator::config']
  -> Class['zram_generator::service']

  $zrams.each |$name, $resource| {
    zram_generator::zram { $name:
      * => $resource,
    }
  }
}
