class profiles::opensshserver::server {

  ## Hiera lookups

  $main_config_options               = hiera_array('profiles::opensshserver::main_config_options')
  $main_config_options_with_kerberos = hiera_array('profiles::opensshserver::main_config_options_with_kerberos')
  $cluster                           = hiera('cluster') 
  $directory_source                  = hiera('profiles::opensshserver::directory_source')
  $enable_kerberos                   = hiera('profiles::auth::client::enable_kerberos')


  if $enable_kerberos {
    $sshd_config_options = union($main_config_options,$main_config_options_with_kerberos)
  }
  else {
    $sshd_config_options = $main_config_options
  }

  # Pass config options as a class parameter
  class { '::opensshserver':
    sshd_config_options => $sshd_config_options,
    cluster             => $cluster,
    directory_source    => $directory_source,
  }
}
