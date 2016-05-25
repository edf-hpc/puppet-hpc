class profiles::hardware::user_tuning {

  ## Hiera lookups

  $config_file    = hiera('profiles::hardware::user_tuning::config_file')
  $config_options = hiera_hash('profiles::hardware::user_tuning::config_options')

  # Call to hpclib::sysctl 
  hpclib::sysctl { $config_file :
    config      => $config_options,
    sysctl_file => $config_file,
  }

}
