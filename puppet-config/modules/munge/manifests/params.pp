class munge::params {


  ### Service ###
  $service_name      = 'munge'
  $service_enable    = true
  $service_ensure    = 'running'
  $service_manage    = true

  ### Configuration ###
  $auth_key_path     = '/etc/munge'
  $auth_key_name     = "${auth_key_path}/munge.key"
  $auth_key_source   = 'munge/munge.key.enc'
  $decrypt_passwd    = 'password'
  $auth_key_mode     = '0400'



  ### Package ###
  $package_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $package_manage =  true
      $package_name = ['munge', 'slurm-munge']
    }
    'Debian': {
      $package_manage =  true
      $package_name = ['munge']
    }
    default: {
      $package_manage =  false
    }
  }
}
