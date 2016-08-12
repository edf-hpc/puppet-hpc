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

# Setup this node as a NAT gateway.
#
# ## Hiera
# * `net_topology` (`hiera_hash`)
# * `profiles::network::nat::source_network`
# * `profiles::network::nat::output_network`
class profiles::network::nat {
  include ::shorewall

  $source_network = hiera('profiles::network::nat::source_network')
  $output_network = hiera('profiles::network::nat::output_network')

  # mynet_topology is and hpclib fact
  if ! has_key($::mynet_topology, $output_network) {
    fail("Network ${output_network} must be configured on this host to activate profiles::network::nat")
  }

  $net_topology = hiera_hash('net_topology')

  $output_interface = $::mynet_topology[$output_network]['interfaces'][0]

  $source_ipnetwork = $net_topology[$source_network]['ipnetwork']
  $source_prefix_length = $net_topology[$source_network]['prefix_length']

  shorewall::masq { "${$output_network}_from_${$source_network}_nat":
    interface => $output_interface,
    source    => "${source_ipnetwork}${source_prefix_length}",
  }

}
