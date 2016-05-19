class profiles::environment::vtune {

  ## Hiera lookups

  $default_options = hiera_hash('profiles::environment::vtune::default_options')

  # Pass config options as a class parameter
  class { '::vtune':
    default_options => $default_options,
    packages        => $packages,
  }
}
