# @summary Class to regenerate swap file units
# @api private
class zram_generator::service {
  exec { 'generate_zram_units':
    path        => '/usr/sbin:/usr/bin',
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  }
}
