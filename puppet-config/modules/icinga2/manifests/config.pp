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

class icinga2::config inherits icinga2 {

  if $::icinga2::config_manage {

    file { $::icinga2::local_defs:
      ensure => $::icinga2::local_defs_ensure
    }

    file { $::icinga2::zones_file:
      content => template('icinga2/zones.erb'),
      owner   => $::icinga2::user,
      group   => $::icinga2::user,
      mode    => 0644,
    }

    create_resources(icinga2::feature, hpc_atoh($::icinga2::features))
  }
}
