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

class openssh::client::config inherits openssh::client {

  augeas { $::openssh::client::config_file:
    context => $::openssh::client::augeas_context,
    require => Package[$::openssh::client::packages],
    changes => $::openssh::client::config_augeas,
  }

  if $::openssh::client::known_hosts_source {
    hpclib::hpc_file { $::openssh::client::known_hosts_file:
      source => $::openssh::client::known_hosts_source,
    }
  }

}
