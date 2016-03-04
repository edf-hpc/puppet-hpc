class profiles::network::base {

  ## Hiera lookups
  $net_keyword       = hiera('network::gw_connect')
  $mlx4load          = hiera('network::mlx4load')
  $net_topology      = hiera_hash('net_topology')
  $bondcfg           = hiera_hash('bondcfg')
  if ! empty($net_keyword) {
    $defaultgw         = $net_topology[$net_keyword]['gateway'] 
  }
  else { $defaultgw = ''}
  $routednet = []

  class { '::network::commons':
    defaultgw                   => $defaultgw,
    routednet                   => $routednet,
    mlx4load                    => $mlx4load,
  }
}
