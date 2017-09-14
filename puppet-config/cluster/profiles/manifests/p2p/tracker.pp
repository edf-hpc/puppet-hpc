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

# Bitorrent tracker
#
# P2P boot system uses opentracker as tracker for the p2p system.
# The tracker is configured to allow admin connections
# from the first node with the `admin` role.
#
# ## Opentracker
#
# Opentracker is configured with two facts to generate the file
# `/etc/default/opentracker`. The configuration file for opentracker daemon
# `/etc/opentracker/opentracker.conf` is generated using default values from
# opentracker puppet module.
#
# ## Facts
# * `hosts_by_role['admin'][0]`
# * `hosts_by_role["$my_p2p_tracker"]`
#
# ## Hiera
# * `profiles::p2p::tracker::listen_networks` (`hiera_array`) List of network
#     the diskless vhost daemon should bind, all if ommited or empty

class profiles::p2p::tracker {
  $listen_networks = hiera_array('profiles::p2p::tracker::listen_networks')
  $admin_node    = $::hosts_by_role['admin'][0]
  $tracker_nodes = $::hosts_by_role["$my_p2p_tracker"]

  if size($listen_networks) > 0 {
    # If listening interfaces are provided add it to the list of listening
    # addresses in the config (including VIPs)
    $ip = hpc_net_ip_addrs($listen_networks, true)

  } else {
    $ip = undef

  }


  class { '::opentracker':
    admin_node          => $admin_node,
    tracker_nodes       => $tracker_nodes,
    listen_ip_addresses => $ip,
  }
}
