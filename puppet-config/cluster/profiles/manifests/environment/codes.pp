class profiles::environment::codes {

  ## Hiera lookups
  $packages = hiera('profiles::environment::codes::packages')


  # Pass config options as a class parameter
  class { '::codes':
    packages => $packages,
  }
}
