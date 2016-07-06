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

class slurm::config {

  ensure_resource('file', $slurm::bin_dir,     {'ensure' => 'directory' })
  ensure_resource('file', $slurm::config_dir,  {'ensure' => 'directory' })
  ensure_resource('file', $slurm::logs_dir,    {'ensure' => 'directory' })
  ensure_resource('file', $slurm::scripts_dir, {'ensure' => 'directory' })

  hpclib::print_config { $::slurm::config_file:
    style      => 'keyval',
    data       => $::slurm::_config_options,
    exceptions => ['Include'],
  }

  hpclib::print_config { $::slurm::partitions_file:
    style => 'linebyline',
    data  => $::slurm::partitions_options,
  }

}
