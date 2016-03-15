class slurmclient::params {

  ### config ###
  $config_manage    = true

  ### Package ###
  $package_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $package_manage = true
      $package_name   = ['slurm-sview']
    }
    'Debian': {
      $package_manage = true
      $package_name   = ['sview']
    }
    default: {
      $package_manage = false
    }
  }
}
