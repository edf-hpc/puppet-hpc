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

class slurm::config {

  ensure_resource('file', $slurm::bin_dir,     {'ensure' => 'directory', mode => '0755' })
  ensure_resource('file', $slurm::config_dir,  {'ensure' => 'directory', mode => '0755' })
  ensure_resource('file', $slurm::logs_dir,    {'ensure' => 'directory', mode => '0755' })
  ensure_resource('file', $slurm::scripts_dir, {'ensure' => 'directory', mode => '0755' })

  if $::slurm::enable_topology {
    hpclib::print_config { $::slurm::topology_file:
      style => 'linebyline',
      data  => $::slurm::topology_options,
    }
  }

  hpclib::print_config { $::slurm::config_file:
    style      => 'keyval',
    data       => $::slurm::_config_options,
    exceptions => ['Include'],
  }

  hpclib::print_config { $::slurm::partitions_file:
    style => 'linebyline',
    data  => $::slurm::partitions_options,
  }

  hpclib::print_config { $::slurm::gres_file:
    style => 'linebyline',
    data  => $::slurm::gres_options,
  }

  # manage eventual spank plugins config
  create_resources(::slurm::spank_conf,
                   $::slurm::spank_plugins)

}
