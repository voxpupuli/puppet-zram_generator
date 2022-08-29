# @summary Configuration for zram_generator entries
# @api private
#
class zram_generator::config {
  file { '/usr/lib/systemd/zram-generator.conf.d':
    ensure  => directory,
    owner   => root,
    group   => root,
    purge   => true,
    mode    => '0755',
    recurse => true,
  }
}
