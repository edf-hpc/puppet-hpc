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

define hpc_ha::vserv (
  $ip_address,
  $port,
  $real_server_hosts,
  $lb_algo             = 'rr',
  $lb_kind             = 'DR',
  $delay_loop          = undef,
  $persistence_timeout = undef,
  $protocol            = 'TCP',
  $vip_name            = undef,
) {

  $_name = regsubst($name, '[:\/\n]', '')

  validate_ip_address($ip_address)
  validate_integer($port)
  validate_array($real_server_hosts)

  ::keepalived::lvs::virtual_server { $_name:
    ip_address          => $ip_address,
    port                => $port,
    real_servers        => $real_server_hosts,
    lb_kind             => $lb_kind,
    lb_algo             => $lb_algo,
    delay_loop          => $delay_loop,
    persistence_timeout => $persistence_timeout,
    protocol            => $protocol,
    collect_exported    => false,
  }

  $real_server_resource_names = prefix($real_server_hosts, "${_name}_")
  # this is a bit hacky, we construct a hash with the actual names, to
  # pass it to all the real server resources. Each resource will do it's
  # own lookup to get its host name
  $hosts_ziped = zip($real_server_resource_names, $real_server_hosts)
  $hosts = hash($hosts_ziped)
  ::hpc_ha::rserv { $real_server_resource_names:
    virtual_server => $_name,
    port           => $port,
    real_hosts     => $hosts,
  }

  # In direct routing, it is necessary to setup a script to configure
  # the IP address on the loopback in backup. We need to attach this script
  # to the notify script from the virtual IP address
  if $lb_kind == 'DR' {
    if $vip_name {
      ::hpc_ha::vip_notify_script { $_name:
        ensure   => present,
        vip_name => $vip_name,
        content  => template('hpc_ha/vserv_notify_script.erb'),
      }
    } else {
      fail('When defining a virtual server with direct routing, specifying vip name (hpc_ha::vip) is mandatory.')
    }
  }
}
