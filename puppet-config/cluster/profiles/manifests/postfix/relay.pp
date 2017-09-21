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

# Setup a Postfix relay
#
# ## Hiera
# * `profiles::postfix::relay::config_options`
# * `net_topology`
# * `profiles::postfix::relay::listen_networks` (`hiera_array`) List of
#     networks the postfix master should listen on, leave the default
#     if ommited or empty. Do NOT include the VIPs, so don't use it if
#     one of the client is supposed to use a VIP to contact this server.
class profiles::postfix::relay {

  ## Hiera lookups
  $options         = hiera_hash('profiles::postfix::relay::config_options')

  # Derfine inet_interfaces
  $listen_networks = hiera_array('profiles::postfix::relay::listen_networks', [])
  if size($listen_networks) > 0 {
    # If listening interfaces are provided add it to the list of listening
    # addresses in the config. VIP are not included because postfix
    # can't start if one of the IP addresses does not exists.
    $ip_addrs = hpc_net_ip_addrs($listen_networks, true)
    $ip = concat(['127.0.0.1'], $ip_addrs)

    $listen_options_snippet = {
      'inet_interfaces' => join($ip, ',')
    }

  } else {
    $listen_options_snippet = {}
  }
  $listen_options = deep_merge($options, $listen_options_snippet)

  # Define mynetworks
  $net_topology    = hiera_hash('net_topology')
  $network         = "${net_topology['administration']['ipnetwork']}${net_topology['administration']['prefix_length']}"
  $net_options     = {
    mynetworks => "${network} 127.0.0.0/8",
  }
  $full_options = deep_merge($listen_options, $net_options)

  # Pass config options as a class parameter
  class { '::postfix':
    config_options => $full_options,
  }
}
