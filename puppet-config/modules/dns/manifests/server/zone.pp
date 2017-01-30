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

define dns::server::zone (
  $entries,
  $type  = 'master',
  $order = 0,
) {

  $final_order = $order + 11
  $db_file = "${::dns::server::config_dir}/db.${name}"
  $origin = "${name}."

  concat::fragment { "conf_local_zone_${name}":
    target  => $::dns::server::local_file,
    order   => $final_order,
    content => template('dns/zone_decl.erb'),
  }

  file { $db_file:
    content => template('dns/db_cluster.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => Service[$::dns::server::services],
  }

}

