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

# Local network configuration
#
# ## Hiera
# * `net_topology` (`hiera_hash`)   Global description of the network
#                                   topology of the cluster
# * `profiles::network::gw_connect` Name of the network to get the default
#                                   gateway from.
# * `profiles::network::ib_enable`  Boolean to control if Infiniband stack is
#                                   deployed (default: false)
# * `profiles::network::opa_enable` Boolean to control if Intel Omni-Path stack
#                                   is deployed (default: false)
#
# ## Relevant Autolookups
# * `infiniband::mlx4load`     Load `mlx4` Driver for Mellanox
#                              ConnectX-3 cards
# * `network::bonding_options` Interface bonding configuration
class profiles::network::base {

  ## Hiera lookups
  $net_keyword  = hiera('profiles::network::gw_connect')
  $ib_enable  = hiera('profiles::network::ib_enable', false)
  $opa_enable = hiera('profiles::network::opa_enable', false)
  $net_topology = hiera_hash('net_topology')
  if ! is_hash($net_topology[$net_keyword]) {
    fail("Undefined WAN network ${net_keyword} in \$net_topology.")
  }
  $defaultgw = $net_topology[$net_keyword]['gateway']
  $fqdn      = $mymasternet['fqdn']

  if $ib_enable {
    class { '::infiniband':
      stage => 'first',
    }
  }
  if $opa_enable {
    class { '::opa':
      stage => 'first',
    }
  }
  class { '::network':
    defaultgw => $defaultgw,
    stage     => 'first',
    fqdn      => $fqdn,
  }

  # Infiniband and OPA classes must be realized before network class because
  # network may configure IP-over-IB interfaces whose initialization of the
  # inner device is done by the other two classes.
  if defined(Class['::infiniband']) {
    Class['::infiniband'] -> Class['::network']
  }
  if defined(Class['::opa']) {
    Class['::opa'] -> Class['::network']
  }
}
