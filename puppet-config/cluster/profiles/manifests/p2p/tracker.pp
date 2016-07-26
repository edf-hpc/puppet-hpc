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

class profiles::p2p::tracker {

  $admin_node    = $hosts_by_role['admin'][0]
  $tracker_nodes = $hosts_by_role["$my_p2p_tracker"]

  class { '::opentracker':
    admin_node    => $admin_node,
    tracker_nodes => $tracker_nodes,
  }
}
