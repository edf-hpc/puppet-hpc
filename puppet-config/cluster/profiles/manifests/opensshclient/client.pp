class profiles::opensshclient::client {

  ## Hiera lookups

  $main_config_options = hiera_array('profiles::opensshclient::main_config_options')
  $public_key          = hiera('profiles::opensshclient::public_key')
  $cluster             = hiera('cluster')

  # Pass config options as a class parameter
  class { '::opensshclient':
    main_config_options => $main_config_options,
    cluster             => $cluster,
    public_key          => $public_key,
  }
}
