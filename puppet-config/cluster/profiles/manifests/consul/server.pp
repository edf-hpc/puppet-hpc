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

class profiles::consul::server {

  # TODO: migrate all comments to the profile documentation in Puppet Strings
  # format.

  # The list of packages is different for the client and server profiles. For
  # this reason, we cannot use autolookup for this parameter, there are
  # variables specific to each profile.
  $packages    = hiera_array('profiles::consul::server::packages')

  # Even though all consul agent (client and servers) could potentially have
  # services, in our architecture only the servers actually have services. We
  # could eventually define the services by autolookup in the hiera private
  # roles specific YAML files but it means duplicating services definitions.
  # These services definitions are rather generic in our architecture, then it
  # is better to define them only once in common.yaml for all clusters.
  $subservices = hiera_array('profiles::consul::server::subservices')

  # The binding IP address is the IP address of the interface on the
  # administration network.
  $binding    = $::hostfile[$::hostname]

  # The list of consul cluster nodes is the list of hosts having either the
  # consul::client or the consul::server profile
  $nodes      = concat(hpc_get_hosts_by_profile('consul::client'),
                       hpc_get_hosts_by_profile('consul::server'))

  # The bootstrap expect is equal the quorum size, which is the number of
  # consul servers divided by 2 rounded to the integer below + 1. Ex:
  # for 3 consul servers: 3/2 = 1.5 rounded to 1. 1 + 1 => 2
  # The division of 2 integers in Puppet round to the integer below. See
  # reference:
  # https://docs.puppet.com/puppet/latest/reference/lang_data_number.html#integers
  $bootstrap = size(hpc_get_hosts_by_profile('consul::server')) / 2 + 1

  class { '::consul':
    packages    => $packages,
    mode        => 'server',
    binding     => $binding,
    nodes       => $nodes,
    bootstrap   => $bootstrap,
    subservices => $subservices
  }
}
