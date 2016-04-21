class profiles::environment::base {

  ## Hiera lookups

  $motd_content           = hiera_hash('profiles::environment::motd_content')
  $cluster                = hiera('cluster')
  $authorized_users_group = hiera('profiles::environment::authorized_users_group')

  # Pass config options as a class parameter
  class { '::environment':
    motd_content           => $motd_content,
    cluster                => $cluster,
    authorized_users_group => $authorized_users_group,
  }
}
