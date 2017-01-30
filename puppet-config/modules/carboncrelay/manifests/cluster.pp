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
define carboncrelay::cluster (
  $type         = $::carboncrelay::params::cluster_type,
  $destinations = [],
  $order        = $::carboncrelay::params::cluster_order,
) {
  validate_string($type)
  validate_hash($destinations)
  validate_string($order)

  $supported_types = [ 'forward', 'any_of', 'failover' ]
  if ! member($supported_types, $type) {
    fail("Cluster type (${type}) for cluster ${name} is not supported (${supported_types}).")
  }

  concat::fragment {"'carboncrelay_config_cluster_${name}":
    target  => $::carboncrelay::config_file,
    order   => $order,
    content => template('carboncrelay/config.cluster.erb'),
  }

}
