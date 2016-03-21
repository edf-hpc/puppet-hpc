#
class nfs_server::params {

# Module variables
  $cfg                = '/etc/exports'
  $pkgs_ensure        = 'present'
  $serv_ensure        = 'running'
  case $::osfamily {
    'Debian': {
      $pkgs           = ['nfs-kernel-server']
      $serv           = 'nfs-kernel-server'
    }
    'Redhat': {
      $pkgs           = ['nfs-utils.x86_64']
      case $::operatingsystemmajrelease {
        '7': { 
          $serv       = 'nfs-server'
        }
        default: {
          $serv       = 'nfs'
        }
      }
    }
    default: {}
  }

}

