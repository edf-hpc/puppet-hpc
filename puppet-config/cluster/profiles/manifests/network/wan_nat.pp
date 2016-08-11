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
# Activate a firewall, the interface corresponding to the `wan` network
# is configured to be masquerading the `administration` network.
#
# ## Hiera
# * `net_topology` (`hiera_hash`)
class profiles::network::wan_nat {
  include ::shorewall

  # mynet_topology is and hpclib fact
  if ! has_key($::mynet_topology, 'wan') {
    fail("Network 'wan' must be configured on this host to activate profiles::network::wan_nat")
  }

  $net_topology = hiera_hash('net_topology')

  $wan_interface = $::mynet_topology['wan']['interfaces'][0]

  shorewall::masq { 'wan_from_administration_nat':
    interface => $wan_interface,
    source    => "${net_topology['administration']['ipnetwork']}${net_topology['administration']['prefix_length']}",
  }

}
