class profiles::hostkeys::base {

  ## Hiera lookups

  $directory_source = hiera('profiles::hostkeys::directory_source')

  # Pass config options as a class parameter

  class { '::hostkeys':
    directory_source => $directory_source,
  }
}
