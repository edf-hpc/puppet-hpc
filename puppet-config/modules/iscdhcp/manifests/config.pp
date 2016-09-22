##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2016 EDF S.A.                                      #
#  Contact: CCN-HPC <dsp-cspit-ccn-hpc@edf.fr>                           #
#                                                                        #
#  This program is free software; you can redistribute in and/or         #
#  modify it under the terms of the GNU General Public License,          #
#  version 2, as published by the Free Software Foundation.              #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
##########################################################################

#
class iscdhcp::config inherits iscdhcp {

  hpclib::print_config { $iscdhcp::default_file :
    style   => 'linebyline',
    data    => $::iscdhcp::default_options,
    require => Package[$::iscdhcp::packages],
  }

  $global_options = $::iscdhcp::global_options
  $my_address     = $::iscdhcp::my_address
  $peer_address   = $::iscdhcp::peer_address

  # dhcpd.conf
  concat {$::iscdhcp::config_file:
    require => Package[$::iscdhcp::packages]
  }
  concat::fragment { 'dhcp-conf-global':
    target  => $::iscdhcp::config_file,
    content => template('iscdhcp/dhcp.conf.global.erb'),
    order   => '01',
  }
  concat::fragment { 'dhcp-conf-sharednet':
    target  => $::iscdhcp::config_file,
    content => template('iscdhcp/dhcp.conf.sharednet.erb'),
    order   => '02',
  }
  $defaults = {
    'my_address'      => $::iscdhcp::my_address,
    'bootmenu_url'    => $::iscdhcp::bootmenu_url,
    'ipxebin'         => $::iscdhcp::ipxebin,
    'dhcp_config'     => $::iscdhcp::dhcp_config,
  }
  create_resources(iscdhcp::include, $::iscdhcp::includes, $defaults)
}
