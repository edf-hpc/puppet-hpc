#
class nfs_client::params {

# Module variables
  $pkgs_ensure        = 'present'
  $serv_ensure        = 'running'
  case $::osfamily {
    'Debian': {
      $pkgs           = ['nfs-common']
      $serv           = 'nfs-common'
    } 
    'Redhat': {
      $pkgs           = ['nfs-utils.x86_64']
      $serv           = 'nfs'
    }
    default: {
    }
  }

}
