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

class slurm::dbd::params {
  require ::slurm

  ### Service ###
  $service_enable   = true
  $service_ensure   = 'running'
  $service_manage   = true
  $service          = 'slurmdbd'

  ### Configuration ###
  $config_manage     = true
  $config_file       = "${::slurm::config_dir}/slurmdbd.conf"
  $db_file           = "${::slurm::config_dir}/slurm-mysql.conf"
  $db_backup_script  = '/usr/local/bin/slurmdbd-backup.sh'
  $db_backup_source  = 'puppet:///modules/slurm/slurmdbd-backup.sh'
  $db_backup_file    = "${::slurm::config_dir}/slurmdbd-backup.vars"

  $config_options_defaults = {
    'DbdHost'           => 'localhost',
    'DbdBackupHost'     => '',
    'DbdPort'           => '6819',
    'SlurmUser'         => 'slurm',
    'DebugLevel'        => '3',
    'AuthType'          => 'auth/munge',
    'AuthInfo'          => '/var/run/munge/munge.socket.2',
    'PidFile'           => '/var/run/slurm-llnl/slurmdbd.pid',
    'StorageType'       => 'accounting_storage/mysql',
    'StorageHost'       => 'localhost',
    'StorageBackupHost' => '',
    'StorageUser'       => 'slurm',
    'StoragePass'       => 'password',
  }

  $db_options_defaults = {
    'db' => {
      'hosts'    => 'localhost',
      'user'     => 'root',
      'password' => 'password',
    },
    'passwords' => {
      'slurm'    => 'password',
      'slurmro'  => 'password',
    },
    'hosts' => {
      'controllers' => '',
      'admins'      => '',
    },
  }

  case $::osfamily {
    'RedHat': {
      $db_client_file = '/etc/mysql/my.cnf'
      $dbbackup_enable = true
    }
    'Debian': {
      $db_client_file = '/etc/mysql/debian.cnf'
      $db_backup_enable = true
    }
    default: {
      $db_backup_enable = false
    }
  }

  $db_backup_options_defaults = {
    'BKDIR'                => '/var/lib/slurmdbd-backup',
    'ACCTDB'               => 'slurm_acct_db',
    'DBMAINCONF'           => $db_client_file,
  }


  ### Package ###
  $packages_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $packages_manage = true
      $packages        = ['slurm-slurmdbd']
    }
    'Debian': {
      $packages_manage = true
      $packages        = [
        'slurmdbd',
        'slurm-llnl-setup-mysql',
      ]
    }
    default: {
      $packages_manage = false
    }
  }
}
