class profiles::opensshserver::server {

  ## Hiera lookups

  $main_config_options = hiera_array('profiles::opensshserver::main_config_options')

  # Pass config options as a class parameter
  class { '::opensshserver':
    main_config_options => $main_config_options,
  }
}
