class profiles::opensshclient::client {

  ## Hiera lookups

  $main_config_options = hiera_array('profiles::opensshclient::main_config_options')

  # Pass config options as a class parameter
  class { '::opensshclient':
    main_config_options => $main_config_options,
  }
}
