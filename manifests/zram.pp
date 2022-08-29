# @summary Creates a zram device and optionally mounts it
# 
# @example Create zram device with default `zram_size`
#   zram_generator::zram{'zram0':
#     ensure => 'present',
#   }
#
# @example Disable a particular swap
#   zram_generator::zram{'zram1':
#     ensure => 'absent',
#   }
#
# @example Create zram device with half ram size and host memory limit
#   zram_generator::zram{'zram1':
#     host_memory_limit => 9048,
#     zram_size         => 'ram / 2',
#   }
#
# @example Create zram device with exact 1024 MiB size
#   zram_generator::zram{'zram2':
#     zram_size         => 1024,
#   }
#
# @example Create a ext4 filesystem and mount at location.
#  zram_generator::zram{'zram2':
#    fs_type            => 'ext4',
#    mount_point        => '/run/compressed-mount-point',
#  }
#
# @see zram_generator https://github.com/systemd/zram-generator/blob/main/man/zram-generator.conf.md
#
# @param device
#   The name of device to create, e.g. `zram0`.
#
# @param ensure
#   Configure and start device or stop and de-cofnigure device
#
# @param host_memory_limit 
#   The maximum amount of memory (in MiB). If set to `none` then there will be no limit. 
#   If unset 
#
# @param zram_size
#   The size of the zram device, as a function of MemTotal, both in MB.
#
# @param compression_algorithm
#   Specifies the algorithm used to compress the zram device.
#
# @param writeback_device
#   Write incompressible pages, for which no gain was achieved, to the specified device under memory pressure. 
#   This corresponds to the /sys/block/zramX/backing_dev parameter.
#   Takes a path to a block device, like /dev/disk/by-partuuid/2d54ffa0-01 or /dev/zvol/tarta-zoot/swap-writeback.
#   If unset, none is used, and incompressible pages are kept in RAM.
#
# @param swap_priority
#   Controls the relative swap priority. Higher numbers indicate higher priority.
#
# @param mount_point
#   Format the device with a file system (not as swap) and mount this file system over 
#   the specified directory. When neither this option nor `fs_type` is specified, 
#   the device will be formatted as swap.
#
# @param fs_type
#  Specifies how the device shall be formatted. The default is ext2 if mount-point is specified, and swap 
#  otherwise. (Effectively, the device will be formatted as swap, if neither fs-type= nor mount-point= are specified.)
#  Note that the device is temporary: contents will be destroyed automatically after the file system is unmounted 
#  (to release the backing memory).
#
# @param options
#   Sets mount or swapon options. Availability depends on fs-type.
#
define zram_generator::zram (
  Pattern[/\Azram\d+\z/] $device                      = $title,
  Enum['present','absent'] $ensure                    = 'present',
  Variant[Enum['none'],Integer[0]] $host_memory_limit = 'none',
  Variant[Integer[1], String[1]] $zram_size           = 'min(ram / 2, 4096)',
  Optional[String[1]] $compression_algorithm          = undef,
  Optional[Stdlib::Unixpath] $writeback_device        = undef,
  Integer[-1,32767] $swap_priority                    = 100,
  Optional[Stdlib::Unixpath] $mount_point             = undef,
  Optional[String[1]] $fs_type                        = undef,
  String[1] $options                                  = 'discard',

) {
  include zram_generator

  $_device_file = "/usr/lib/systemd/zram-generator.conf.d/${device}.conf"

  $_file_ensure = $ensure ? {
    'present' => 'file',
    default   => 'absent',
  }

  file { $_device_file:
    ensure  => $_file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('zram_generator/device.conf.epp',
      {
        'device'                => $device,
        'host_memory_limit'     => $host_memory_limit,
        'zram_size'             => $zram_size,
        'compression_algorithm' => $compression_algorithm,
        'writeback_device'      => $writeback_device,
        'swap_priority'         => $swap_priority,
        'mount_point'           => $mount_point,
        'fs_type'               => $fs_type,
        'options'               => $options,
      }
    ),
  }

  $_service = "dev-${device}.swap"
  $_service_ensure = $ensure ? {
    'present' => true,
    default   => false
  }

  service { $_service:
    ensure => $_service_ensure,
    enable => $_service_ensure,
  }

  if $ensure == 'present' {
    File[$_device_file] ~> Class[zram_generator::service] ~> Service[$_service]
  } else {
    Service[$_service] -> File[$_device_file] ~> Class[zram_generator::service]
  }
}
