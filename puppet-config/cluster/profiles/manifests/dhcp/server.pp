#
class profiles::dhcp::server {

  ## Hiera lookups
  $default_options = hiera_array('profiles::dhcp::default_options')
  $global_options  = hiera_array('profiles::dhcp::global_options')
  $failover        = hiera_hash('profiles::dhcp::failover')
  $sharednet       = hiera_hash('profiles::dhcp::sharednet')
  $includes        = hiera_hash('profiles::dhcp::includes')
  $bootmenu_url    = hiera('profiles::dhcp::bootmenu_url')
  $ipxebin         = hiera('profiles::dhcp::ipxebin')

  $my_address      = $::hostfile[$::hostname]
  $dhcp_config     = $::dhcpconfig
  $prefix          = hiera('cluster_prefix')
  
  # Primary server has an index of 1
  # Secondary server has an index of 2 
  if $::puppet_index == '1' {
    $peer_address  = $::hostfile["${prefix}${::puppet_role}2"]
    $failover_add = {
      role            => 'primary',
      load_split      => '128',
    }
  } else {
    $peer_address  = $::hostfile["${prefix}${::puppet_role}1"]
    $failover_add = {
      role            => 'secondary',
      load_split      => '',
    }
  }
  $_failover = merge($failover, $failover_add)
  $virtual_address = $::hostfile["${prefix}${::puppet_role}"]

  # Pass config options as a class parameter
  class { '::iscdhcp':
    my_address      => $my_address,
    peer_address    => $peer_address,
    virtual_address => $virtual_address,
    dhcp_config     => $dhcp_config,
    bootmenu_url    => $bootmenu_url,
    ipxebin         => $ipxebin,
    default_options => $default_options,
    global_options  => $global_options,
    failover        => $_failover,
    sharednet       => $sharednet,
    includes        => $includes,
  }

}
