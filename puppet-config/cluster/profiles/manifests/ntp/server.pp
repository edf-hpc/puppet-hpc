class profiles::ntp::server {

  ## Hiera lookups
  $preferred_servers = hiera_array('profiles::ntp::server::site_preferred_servers')
  $servers           = hiera_array('profiles::ntp::server::site_servers')

  $net_topology      = hiera_hash('net_topology')
  $ip		     = $net_topology['allloc']['ipnetwork']
  $netmask	     = $net_topology['allloc']['netmask']
  $restrict          = ["-4 $ip mask $netmask notrap nomodify"]
 
  # Pass server name as a class parameter
  class { '::ntp::commons':
    preferred_servers           => $preferred_servers,
    servers                     => $servers,
    restrict			=> $restrict,
  }
}
