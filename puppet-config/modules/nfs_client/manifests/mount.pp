#
define nfs_client::mount (
  $server,
  $exportdir,
  $mountpoint,
  $opts,
  $ensure               = 'mounted',
  $atboot               = true,
  $remounts             = false,  
  $pass                 = 2,
  $dump                 = 0,
){

  # Make sure the mount point exists
  exec {"creating_${mountpoint}":
    command       => "mkdir -p ${mountpoint}",
    unless        => "test -d ${mountpoint}",
    path          => $::path,
  }
  
  file {"${mountpoint}":
    ensure        => 'directory',
    require       => Exec["creating_${mountpoint}"],
  }

  # Mount the device
  mount {"${mountpoint}":
    ensure        => $ensure,
    device        => "${server}:${exportdir}",
    fstype        => 'nfs',
    atboot        => $atboot,
    options       => $opts, 
    pass          => $pass,
    remounts      => $remounts,
    dump          => $dump,
  }

} 
