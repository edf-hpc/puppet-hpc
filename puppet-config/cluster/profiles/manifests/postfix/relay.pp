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

# Setup a Postfix relay
#
# ## Hiera
# * `profiles::postfix::relay::config_options`
# * `net_topology`
class profiles::postfix::relay {

  ## Hiera lookups
  $options      = hiera_hash('profiles::postfix::relay::config_options')
  $net_topology = hiera_hash('net_topology')
  $network      = "${net_topology['administration']['ipnetwork']}${net_topology['administration']['prefix_length']}"
  $net_options     = {
    mynetworks => "${network} 127.0.0.0/8",
  }
  $full_options = merge($options,$net_options)

  # Pass config options as a class parameter
  class { '::postfix':
    config_options => $full_options,
  }
}
