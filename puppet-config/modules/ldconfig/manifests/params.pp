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

class ldconfig::params {
  $service_manage       = true
  $service_name         = 'ldconfig-refresh'
  $service_ensure       = undef
  $service_enable       = true
  $service_definition   = {
    'Unit' => {
      'Description' => 'Refresh ldconfig configuration',
    },
    'Service' => {
      'Type'         => 'oneshot',
      'ExecStartPre' => '/bin/sleep 10',
      'ExecStart'    => '/sbin/ldconfig',
    },
  }
  $service_triggers = []
  $ldconfig_directories = []
}
