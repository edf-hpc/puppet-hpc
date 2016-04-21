define hpc_ha::vip (
  $prefix = '',
  $net_id,
  $ip_address,
  $router_id,
  $auth_secret,
) {
  
  validate_string($net_id)
  validate_string($prefix)
  validate_ip_address($ip_address)
  validate_integer($router_id)
  validate_string($auth_secret)

  $interface = $mynet_topology[$net_id]['interfaces'][0]
  validate_string($interface)

  $up_name = upcase($name)
  $up_prefix = upcase($prefix)

  $vrrp_instance_id= "VI_${up_prefix}${up_name}"

  ::keepalived::vrrp::instance { $vrrp_instance_id:
    interface         => $interface,
    state             => 'BACKUP',
    virtual_router_id => $router_id,
    priority          => '100',
    auth_type         => 'PASS',
    auth_pass         => $auth_secret,
    virtual_ipaddress => [ $ip_address ],
  }
}
