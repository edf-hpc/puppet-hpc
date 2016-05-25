#
define iscdhcp::include ($pool_name, $subnet_name, $tftp, $pool, $my_address, $virtual_address, $bootmenu_url, $ipxebin, $dhcp_config) {

  file { $pool['include'] :
    content => template('iscdhcp/dhcp.conf.include.erb'),
  }

}
