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

class slurm::dbd::config inherits slurm::dbd {

  if $::slurm::dbd::config_manage {

    hpclib::print_config { $::slurm::dbd::config_file:
      style => 'keyval',
      data  => $::slurm::dbd::_config_options,
    }

    hpclib::print_config { $::slurm::dbd::db_file:
      style => 'ini',
      data  => $::slurm::dbd::_db_options,
    }

    if $::slurm::dbd::db_manage {
      exec { "${::slurm::dbd::db_setup_exec} create":
        unless  => "${::slurm::dbd::db_setup_exec} check",
        require => Hpclib::Print_Config[ $::slurm::dbd::db_file ],
      }
    }

    if $::slurm::dbd::db_backup_enable {

      file { $::slurm::dbd::db_backup_script :
        source => $::slurm::dbd::db_backup_src,
        mode   => '0755',
      }

      hpclib::print_config { $::slurm::dbd::db_backup_file :
        style => 'keyval',
        data  => $::slurm::dbd::db_backup_options,
      }

      cron { 'dbbackup':
        command => $::slurm::dbd::db_backup_script,
        user    => 'root',
        hour    => 2,
        minute  => 0,
      }

    }
  }
}
