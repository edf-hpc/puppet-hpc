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

class dns::server::config inherits dns::server {

  if $::dns::server::manage_config {

    file { $::dns::server::config_file:
      content => template('dns/named_conf_options.erb'),
      notify  => Service[$::dns::server::services],
    }

    concat { $::dns::server::local_file:
      mode   => 0644,
      owner  => 'root',
      group  => 'root',
      notify => Service[$::dns::server::services],
    }

    concat::fragment { 'conf_local_header':
      target  => $::dns::server::local_file,
      content => template('dns/named_conf_local.erb'),
    }

    create_resources(dns::server::zone, $::dns::server::zones)

  }
}
