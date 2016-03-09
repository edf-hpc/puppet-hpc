class profiles::ssmtp::client {

  ## Hiera lookups

  $ext_cfg_opts      = hiera_hash('profiles::ssmtp::client::ssm_opts')

  # Pass config options as a class parameter
  class { '::ssmtp':
    ext_cfg_opts       => $ext_cfg_opts,
  }
}
