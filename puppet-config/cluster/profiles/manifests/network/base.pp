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

# Local network configuration
#
# ## Hiera
# * `net_topology` (`hiera_hash`)   Global description of the network
#                                   topology of the cluster
# * `profiles::network::gw_connect` Name of the network to get the default
#                                   gateway from.
#
# ## Relevant Autolookups
# * `network::mlx4load`        Load `mlx4` Driver for Mellanox
#                              ConnectX-3 cards
# * `network::bonding_options` Interface bonding configuration
class profiles::network::base {

  ## Hiera lookups
  $net_keyword  = hiera('profiles::network::gw_connect')
  $net_topology = hiera_hash('net_topology')
  if ! is_hash($net_topology[$net_keyword]) {
    fail("Undefined WAN network ${net_keyword} in \$net_topology.")
  }
  $defaultgw = $net_topology[$net_keyword]['gateway']

  class { '::network':
    defaultgw => $defaultgw,
  }
}
