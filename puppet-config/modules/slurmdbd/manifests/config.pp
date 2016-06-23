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

class slurmdbd::config {

  if $slurmdbd::config_manage {

    ensure_resource('file', $::slurmdbd::bin_dir_path,  {'ensure' => 'directory' })
    ensure_resource('file', $::slurmdbd::conf_dir_path, {'ensure' => 'directory' })
    ensure_resource('file', $::slurmdbd::logs_dir_path, {'ensure' => 'directory' })

    hpclib::print_config { $slurmdbd::main_conf_file :
      style   => 'keyval',
      data    => $slurmdbd::main_conf_options,
      require => File[$slurmdbd::conf_dir_path],
    }

    hpclib::print_config { $slurmdbd::dbd_conf_file :
      style   => 'ini',
      data    => $slurmdbd::dbd_conf_options,
      require => File[$slurmdbd::conf_dir_path],
    }

    exec { '/usr/sbin/slurm-mysql-setup create':
      unless  => '/usr/sbin/slurm-mysql-setup check',
      require => Hpclib::Print_Config[ $slurmdbd::dbd_conf_file ],
    }

    if $slurmdbd::dbbackup_enable {
      file { $slurmdbd::dbd_backup_script :
        source  => $slurmdbd::dbd_backup_src,
        mode    => '0755',
        require => File[$slurmdbd::bin_dir_path],
      }

      hpclib::print_config { $slurmdbd::dbd_backup_include :
        style   => 'keyval',
        data    => $slurmdbd::backup_include_options,
        require => File[$slurmdbd::conf_dir_path],
      }
      cron { 'dbbackup':
        command => $slurmdbd::dbd_backup_script,
        user    => 'root',
        hour    => 2,
        minute  => 0,
        require => File[$slurmdbd::dbd_backup_script]
      }
    }
  }
}
