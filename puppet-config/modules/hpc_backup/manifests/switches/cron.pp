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

# Launch a switch backup script periodically
#
# @param target_dir Absolute path of the local directory
# @param source_nodeset ClusterShell nodeset of the switches
# @param name Type of switch
define hpc_backup::switches::cron(
  $target_dir,
  $source_nodeset,
) {

  validate_absolute_path($target_dir)
  validate_string($source_nodeset)

  $basedir = dirname($target_dir)
  ensure_resource(file, $basedir, {'ensure' => 'directory'})

  $options = {
    'BKDIR'            => "'${target_dir}'",
    'KEEP_OLD'         => 'false',
    'SWITCHES_NODESET' => "'${source_nodeset}'",
  }

  hpclib::print_config{"/etc/hpc-hardware/backup-switches-${name}.vars":
    style => 'keyval',
    data  => $options,
  }

  $script_file = "/usr/sbin/backup-switches-${name}"
  cron { "hpc_backup_switches_cron_${name}":
    command => $script_file,
    user    => 'root',
    hour    => '2',
    minute  => '0',
  }

}

