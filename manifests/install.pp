# @summary Install zram-generator pacakge
# @api private
#
class zram_generator::install (
  Enum['installed', 'absent'] $install_defaults = $zram_generator::install_defaults,
  Boolean $manage_defaults_package = $zram_generator::manage_defaults_package,
) {
  if $manage_defaults_package {
    package { 'zram-generator-defaults':
      ensure => $install_defaults,
    }
  }

  package { 'zram-generator':
    ensure => installed,
  }
}
