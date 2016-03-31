class profiles::hostkeys::base {

  ## Hiera lookups

  $hostkeys_directory_source = hiera('profiles::hostkeys::hostkeys_directory_source')

  # Pass config options as a class parameter

  class { '::hostkeys':
    hostkeys_directory_source => $hostkeys_directory_source,
  }
}
