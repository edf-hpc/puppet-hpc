#
define tmpfs::mount (
  $opts,
  $mountpoint           = '/tmp',
  $device               = 'none',
  $ensure               = 'defined',
  $atboot               = true,
  $remounts             = false,
  $pass                 = 0,
  $dump                 = 0,
) {

  # Mount the device
  mount {"${mountpoint}":
    ensure        => $ensure,
    device        => $device,
    fstype        => 'tmpfs',
    atboot        => $atboot,
    options       => $opts,
    pass          => $pass,
    remounts      => $remounts,
    dump          => $dump,
  }

}
