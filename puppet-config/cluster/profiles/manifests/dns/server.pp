class profiles::dns::server {

  ## Hiera lookups

  $net_topology = hiera_hash('net_topology')
  $site_opts    = hiera_hash('profiles::dns::server::site_opts')
  $domain       = hiera('domain')

  # Pass config options as a class parameter
  class { '::dns::server':
    site_opts   => $site_opts,
    domain      => $domain,
  }
}
