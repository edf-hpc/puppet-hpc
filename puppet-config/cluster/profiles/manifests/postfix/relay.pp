class profiles::postfix::relay {

  ## Hiera lookups

  $pos_opts     = hiera_hash('profiles::postfix::relay::pos_opts')
  $net_topology = hiera_hash('net_topology')
  $network      = "${net_topology['clusterloc']['ipnetwork']}${net_topology['clusterloc']['cidr']}"
  $net_opts     = {
    mynetworks    => "$network 127.0.0.0/8",
  }

  $cfg_opts = merge($pos_opts,$net_opts)


  # Pass config options as a class parameter
  class { '::postfix':
    cfg_opts    => $cfg_opts,
  }
}
