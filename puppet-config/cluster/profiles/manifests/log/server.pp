class profiles::log::server {

  ## Hiera lookups

  $server_dir    = hiera('profiles::log::server::server_dir')
  $custom_config = hiera('profiles::log::server::custom_config')


  # Pass config options as a class parameter
  class { '::rsyslog::server':
    server_dir    => $server_dir,
    custom_config => $custom_config,
  }
}
