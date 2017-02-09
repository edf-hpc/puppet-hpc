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

class hpc_backup::switches::config inherits hpc_backup::switches {

  $base_dir_params = {
    'ensure' => 'directory',
    'owner'  => 'root',
    'group'  => 'root',
    'mode'   => '0755',
  }

  ensure_resource(file, $::hpc_backup::switches::base_dir, $base_dir_params)

  $switches_crons = hpc_backup_switches_crons($::hpc_backup::switches::sources,
                                              $::hpc_backup::switches::base_dir)
  create_resources(hpc_backup::switches::cron, $switches_crons)
}
