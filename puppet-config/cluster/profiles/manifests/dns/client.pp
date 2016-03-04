class profiles::dns::client {

  ## Hiera lookups

  $nameservers  = hiera_array('profiles::dns::client::nameservers')
  $search       = hiera('profiles::dns::client::search')
  $domain       = hiera('domain')

  # Pass config options as a class parameter
  class { '::dns::client':
    nameservers => $nameservers,
    search      => $search,
    domain      => $domain,
  }
}
