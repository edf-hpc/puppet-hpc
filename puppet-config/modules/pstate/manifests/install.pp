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

class pstate::install inherits pstate {

  file { $::pstate::script_file:
    ensure => present,
    source => 'puppet:///modules/pstate/pstate_set.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  hpclib::systemd_service { $::pstate::systemd_service_file :
    target => $::pstate::systemd_service_file,
    config => $::pstate::systemd_service_file_options,
  }


}
