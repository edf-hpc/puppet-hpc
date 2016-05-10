class profiles::network::wan_nat {
  class { '::shorewall':
    ip_forwarding => true
  }

  if ! has_key($mynet_topology, 'wan') {
    fail("Network 'wan' must be configured on this host  to activate profiles::network::wan_nat")
  }

  $net_topology = hiera('net_topology')

  $wan_interface = $mynet_topology['wan']['interfaces'][0]

  shorewall::masq { 'wan_from_clusterloc_nat':
    interface => $wan_interface,
    source    => "${net_topology['clusterloc']['ipnetwork']}${net_topology['clusterloc']['cidr']}",
  }

}
