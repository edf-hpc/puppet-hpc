class profiles::ssmtp::client {

  ## Hiera lookups

  $profile_opts      = hiera_hash('profiles::ssmtp::client::ssm_opts')

  # Pass config options as a class parameter
  class { '::ssmtp::client':
    profile_opts       => $profile_opts,
  }
}
