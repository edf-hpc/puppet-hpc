##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2017 EDF S.A.                                      #
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

# Setup inventory collector
#
# ## Hiera
# * `cluster_prefix`
# * `domain`
#
# ## Relevant Autolookups
# * `profiles::inventory::collect::listen_networks` (`hiera_array`) List of network
#     the diskless vhost daemon should bind, all if ommited or empty
#
class profiles::inventory::collect {

  $prefix          = hiera('cluster_prefix')
  $domain          = hiera('domain')
  $virtual_address = $::hostfile["${prefix}${::puppet_role}"]
  $listen_networks = hiera_array('profiles::inventory::collect::listen_networks', [])
  $servername      = "${prefix}${::puppet_role}"
  $serveraliases   = ["${servername}.${domain}"]

  if size($listen_networks) > 0 {
    # If listening interfaces are provided add it to the list of listening
    # addresses in the config (including VIPs)
    $ip_addrs = hpc_net_ip_addrs($listen_networks, true)
    $ip = ['127.0.0.1', $ip_addrs]


    ## Sysctl setup
    # We need a sysctl to enable the ip_nonlocal_bind that will permit
    # apache to bind the VIP on de failover node
    kernel::sysctl { 'profiles_inventory_collect':
      params => {
        'net.ipv4.ip_nonlocal_bind' => '1',
      },
    }

  } else {
    $ip = undef

  }

  include apache
  include apache::mod::php

  class { '::glpicollector':
    virtual_address => $virtual_address,
    servername      => $servername,
    serveraliases   => $serveraliases,
    ip              => $ip,
  }

}
