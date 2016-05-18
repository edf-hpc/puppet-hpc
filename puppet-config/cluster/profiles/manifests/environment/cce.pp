class profiles::environment::cce {

  ## Hiera lookups

  $default_options = hiera_hash('profiles::environment::cce::default_options')

  # Pass config options as a class parameter
  class { '::cce':
    default_options => $default_options,
  }
}
