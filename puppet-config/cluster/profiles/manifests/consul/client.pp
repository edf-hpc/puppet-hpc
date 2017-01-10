##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class profiles::consul::client {

  # TODO: migrate all comments to the profile documentation in Puppet Strings
  # format.

  # The list of packages is different for the client and server profiles. For
  # this reason, we cannot use autolookup for this parameter, there are
  # variables specific to each profile.
  $packages   = hiera_array('profiles::consul::client::packages')

  # The binding IP address is the IP address of the interface on the
  # administration network.
  $binding    = $::hostfile[$::hostname]

  # The list of consul cluster nodes is the list of hosts having either the
  # consul::client or the consul::server profile
  $nodes      = concat(hpc_get_hosts_by_profile('consul::client'),
                       hpc_get_hosts_by_profile('consul::server'))

  class { '::consul':
    packages        => $packages,
    mode            => 'client',
    binding         => $binding,
    nodes           => $nodes
  }
}
