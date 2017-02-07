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

class hpc_backup::collect_dir::config inherits hpc_backup::collect_dir {

  $base_dir_params = {
    'ensure' => 'directory',
    'owner'  => 'root',
    'group'  => 'root',
    'mode'   => '0755',
  }

  ensure_resource(file, $::hpc_backup::collect_dir::base_dir, $base_dir_params)

  $rsync_crons = hpc_backup_rsync_crons($::hpc_backup::collect_dir::sources,
                                        $::hpc_backup::collect_dir::base_dir)
  debug("Created rsync_crons: ${rsync_crons}")
  create_resources(hpclib::rsync_cron, $rsync_crons)
}
