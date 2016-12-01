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

# Configure a Virtual Server
#
# # LoadBalancing algorithms
#
# ## Algorithm
#
# - `rr`: Round-Robin
# - `lc`: Least-Connection
#
# ## Method
#
# - `DR`: Direct-Routing
# - `NAT`: Network Address Translation
# - `TUN`: Tunneling
#
# @param ip_address IP address of the virtual server
# @param port Port the virtual server listens on
# @param real_server_hosts Hosts with the real servers to check
# @param prefixes Prefix to add to the real_server_hosts to known the
#           hostnames to actually check
# @param network DEPRECATED unused
# @param options Options for the real server checks
# @param lb_algo Load balancing algorithm (default: `rr`)
# @param lb_kind Load balancing method (default: `DR`)
# @param delay_loop Interval between checks in seconds
# @param persistence_timeout Every reconnection inside this interval
#           will use the same real server regardless of the load
#           balancing algorithm
# @param protocol 'UDP' or 'TCP' (default: 'TCP')
# @param vip_name Name of the `hpc_ha::vip` resource
define hpc_ha::vserv (
  $ip_address,
  $port,
  $real_server_hosts,
  $prefixes,
  $network,
  $options             = undef,
  $lb_algo             = 'rr',
  $lb_kind             = 'DR',
  $delay_loop          = $::hpc_ha::params::delay_loop,
  $persistence_timeout = $::hpc_ha::params::persistence_timeout,
  $protocol            = 'TCP',
  $vip_name            = undef,
) {

  $_name = regsubst($name, '[:\/\n]', '')

  validate_ip_address($ip_address)
  validate_integer($port)
  validate_integer($persistence_timeout)
  validate_integer($delay_loop)
  validate_array($real_server_hosts)
  validate_string($network)

  ::keepalived::lvs::virtual_server { $_name:
    ip_address          => $ip_address,
    port                => $port,
    lb_kind             => $lb_kind,
    lb_algo             => $lb_algo,
    delay_loop          => $delay_loop,
    persistence_timeout => $persistence_timeout,
    protocol            => $protocol,
    collect_exported    => false,
  }

  $real_server_resource_names = prefix($real_server_hosts, "${_name}_")
  $real_server_hosts_with_pref = prefix($real_server_hosts, $prefixes)

  # this is a bit hacky, we construct a hash with the actual names, to
  # pass it to all the real server resources. Each resource will do it's
  # own lookup to get its host name
  $hosts_ziped = zip($real_server_resource_names, $real_server_hosts_with_pref)
  $hosts = hash($hosts_ziped)

  ::hpc_ha::rserv { $real_server_resource_names:
    virtual_server => $_name,
    port           => $port,
    real_hosts     => $hosts,
    options        => $options,
    network        => $network,
  }

  # In direct routing, it is necessary to setup a script to configure
  # the IP address on the loopback in backup. We need to attach this script
  # to the notify script from the virtual IP address
  if $lb_kind == 'DR' {
    if $vip_name {
      ::hpc_ha::vip_notify_script { "vserv_${_name}":
        ensure   => present,
        vip_name => $vip_name,
        content  => template('hpc_ha/vserv_notify_script.erb'),
      }
    } else {
      fail('When defining a virtual server with direct routing, specifying vip name (hpc_ha::vip) is mandatory.')
    }
  }
}
