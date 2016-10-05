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
        content => template('slurm/slurmdbd-backup.sh.erb'),
        mode    => '0755',
      }

      hpclib::print_config { $::slurm::dbd::db_backup_file :
        style => 'keyval',
        data  => $::slurm::dbd::_db_backup_options,
      }

      cron { 'dbbackup':
        command => $::slurm::dbd::db_backup_script,
        user    => 'root',
        hour    => 2,
        minute  => 0,
      }

    }
    if $::slurm::dbd::sync_enable {

      hpclib::print_config { $::slurm::dbd::sync_conf_file:
        style => 'ini',
        data  => $::slurm::dbd::_sync_options,
      }

      # The sync package already provides a crontab in /etc. Unfortunately, the
      # puppet crontab provider does not support modifying those files. It can
      # only associate cronjobs to users' crontabs. Since we cant to control
      # this cronjob from puppet, the cronjob is defined in root's crontab (by
      # default, as defined in dbd/params.pp) and we ensure the crontab
      # provided by the package is removed (by default) to avoid conflict. This
      # could be easily improved using this external module for eg.:
      #   https://forge.puppet.com/rmueller/cron
      # Check out this issue for reference:
      #   https://github.com/edf-hpc/puppet-hpc/issues/68
      cron { 'syncusers':
        command => $::slurm::dbd::sync_exec,
        user    => $::slurm::dbd::sync_cron_user,
        hour    => $::slurm::dbd::sync_cron_hour,
        minute  => $::slurm::dbd::sync_cron_minute,
      }

      file { $::slurm::dbd::sync_pkg_cron:
        ensure => $::slurm::dbd::sync_pkg_cron_ensure,
      }

    }
  }
}
