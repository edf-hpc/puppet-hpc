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

class slurmcommons::config {

  ensure_resource('file', $slurmcommons::bin_dir_path,    {'ensure' => 'directory' })
  ensure_resource('file', $slurmcommons::conf_dir_path,   {'ensure' => 'directory' })
  ensure_resource('file', $slurmcommons::logs_dir_path,   {'ensure' => 'directory' })
  ensure_resource('file', $slurmcommons::script_dir_path, {'ensure' => 'directory' })

  hpclib::print_config { $slurmcommons::main_conf_file :
    style      => 'keyval',
    data       => $slurmcommons::slurm_conf_options,
    exceptions => ['Include'],
    require    => File[$slurmcommons::conf_dir_path],
  }

  hpclib::print_config { $slurmcommons::part_conf_file :
    style   => 'linebyline',
    data    => $slurmcommons::partitions_conf,
    require => File[$slurmcommons::conf_dir_path],
  }

}
