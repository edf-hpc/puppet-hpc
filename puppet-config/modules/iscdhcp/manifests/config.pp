#
class iscdhcp::config inherits iscdhcp {

  hpclib::print_config { $iscdhcp::default_file :
    style              => 'linebyline',
    data               => $iscdhcp::default_options,
#    notify             => Service[$iscdhcp::service],
    require            => Package[$iscdhcp::packages],
  }

  $global_options = $iscdhcp::global_options
  $failover       = $iscdhcp::failover
  $my_address     = $iscdhcp::my_address
  $peer_address   = $iscdhcp::peer_address
  Concat { require => Package[$iscdhcp::packages] }

  # dhcpd.conf
  concat {  "${iscdhcp::config_file}": }
  concat::fragment { 'dhcp-conf-global':
    target  => "${iscdhcp::config_file}",
    content => template('iscdhcp/dhcp.conf.global.erb'),
    order   => '01',
  }
  concat::fragment { 'dhcp-conf-failover':
    target  => "${iscdhcp::config_file}",
    content => template('iscdhcp/dhcp.conf.failover.erb'),
    order   => '02',
  }
  concat::fragment { 'dhcp-conf-sharednet':
    target  => "${iscdhcp::config_file}",
    content => template('iscdhcp/dhcp.conf.sharednet.erb'),
    order   => '03',
  }
  $defaults = {
    'my_address'      => $my_address,
    'virtual_address' => $virtual_address,
    'bootmenu_url'    => $bootmenu_url,
    'ipxebin'         => $ipxebin,
    'dhcp_config'     => $dhcp_config,
  }
  create_resources(iscdhcp::include,$includes, $defaults)
}
