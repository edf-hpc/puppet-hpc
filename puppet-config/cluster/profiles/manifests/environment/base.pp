class profiles::environment::base {

  ## Hiera lookups

  $motd_content = hiera_hash('profiles::environment::motd_content')

  # Pass config options as a class parameter
  class { '::environment':
    motd_content => $motd_content,
  }
}
