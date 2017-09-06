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

# Metrics relay between local cluster and external server
#
# ## Hiera
# * `profiles::metrics::relay_destination_clusters` (`hiera_array`)
# * `profiles::metrics::relay_match_rules` (`hiera_array`)
# * `profiles::metrics::relay_rewrite_rules` (`hiera_array`)
# * `profiles::metrics::relay::listen_address` Address the carbon-c-relay
#     server will listen on (default: '0.0.0.0')
class profiles::metrics::relay {

  $listen_address = hiera('profiles::metrics::relay::listen_address', '0.0.0.0')
  if $listen_address == '0.0.0.0' {
    $listen_address_actual = undef
  } else {
    $listen_address_actual = $listen_address

    ## Sysctl setup
    # We need a sysctl to enable the ip_nonlocal_bind that will permit
    # carbon-c-relay to bind the VIP on the failover node
    kernel::sysctl { 'profiles_metrics_relay':
      params => {
        'net.ipv4.ip_nonlocal_bind' => '1',
      },
    }
  }

  class { '::carboncrelay' :
    listen_address => $listen_address_actual,
  }

  $clusters = hiera_hash('profiles::metrics::relay_destination_clusters')
  create_resources(::carboncrelay::cluster, $clusters)

  $match_rules = hiera_hash('profiles::metrics::relay_match_rules')
  create_resources(::carboncrelay::match, $match_rules)

  $rewrite_rules = hiera_hash('profiles::metrics::relay_rewrite_rules')
  create_resources(::carboncrelay::rewrite, $rewrite_rules)

}
