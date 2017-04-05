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

class slurm::exec::config inherits slurm::exec {

  if $::slurm::exec::config_manage {
    if $::slurm::exec::enable_cgroup {

      hpclib::print_config { $::slurm::exec::cgroup_file:
        style  => 'keyval',
        data   => $::slurm::exec::_cgroup_options,
        notify => Class['::slurm::exec::service'],
      }

    }

  }

  rsyslog::imfile { 'slurmd':
    file_name     => '/var/log/slurm-llnl/slurmd.log',
    file_tag      => 'slurmd:',
    file_facility => 'info',
  }

}
