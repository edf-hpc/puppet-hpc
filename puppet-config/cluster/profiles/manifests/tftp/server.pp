class profiles::tftp::server {

  ## Hiera lookups

  $ext_cfg_opts      = hiera_hash('profiles::tftp::server::tftp_opts')

  # Pass config options as a class parameter
  class { '::tftp':
    ext_cfg_opts       => $ext_cfg_opts,
  }
}
