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

class pstate::params {

  #### Module variables
  $script_file = '/usr/local/sbin/pstate_set.sh'
  $service     = 'pstate'

  $systemd_service_file         = '/etc/systemd/system/pstate.service'
  $systemd_service_file_options = {
    'Unit'    => {
      'Description' => 'Set Intel pstate tuning',
    },
    'Service' => {
      'Type'      => 'oneshot',
      'ExecStart' => $script_file,
    },
    'Install' => {
      'WantedBy' => 'multi-user.target',
    },
  }

}
