class profiles::opensshserver::server {

  ## Hiera lookups

  $main_config_options       = hiera_array('profiles::opensshserver::main_config_options')
  $cluster                   = hiera('cluster') 
  $rootkeys_directory_source = hiera('profiles::opensshserver::rootkeys_directory_source')


  # Pass config options as a class parameter
  class { '::opensshserver':
    main_config_options       => $main_config_options,
    cluster                   => $cluster,
    rootkeys_directory_source => $rootkeys_directory_source,
  }
}
