class profiles::auth::client {

  ## Hiera lookups

  $config_options = hiera_hash('profiles::auth::client::config_options')
  $cluster        = hiera('cluster')

  # Pass config options as a class parameter
  class { '::sssd':
    config_options => $config_options,
    cluster        => $cluster,
  }
}
