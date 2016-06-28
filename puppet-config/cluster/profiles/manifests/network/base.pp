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
# * `bondcfg` (`hiera_hash`)
# * `net_topology` (`hiera_hash`)
# * `network::gw_connect`
# * `network::mlx4load`
class profiles::network::base {

  ## Hiera lookups
  $net_keyword       = hiera('network::gw_connect')
  $mlx4load          = hiera('network::mlx4load')
  $net_topology      = hiera_hash('net_topology')
  $bondcfg           = hiera_hash('bondcfg')
  if ! empty($net_keyword) {
    $defaultgw         = $net_topology[$net_keyword]['gateway'] 
  }
  else { $defaultgw = ''}
  $routednet = []

  class { '::network':
    defaultgw                   => $defaultgw,
    routednet                   => $routednet,
    mlx4load                    => $mlx4load,
  }
}
