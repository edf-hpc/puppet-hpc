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
  $db_setup_exec     = '/usr/sbin/slurm-mysql-setup'
  $db_backup_script  = '/usr/local/bin/slurmdbd-backup.sh'
  $db_backup_file    = "${::slurm::config_dir}/slurmdbd-backup.vars"

  $config_options_defaults = {
    'DbdHost'           => 'localhost',
    'DbdPort'           => '6819',
    'SlurmUser'         => 'slurm',
    'DebugLevel'        => '3',
    'AuthType'          => 'auth/munge',
    'AuthInfo'          => '/var/run/munge/munge.socket.2',
    'PidFile'           => '/var/run/slurm-llnl/slurmdbd.pid',
    'StorageType'       => 'accounting_storage/mysql',
    'StorageHost'       => 'localhost',
    'StorageUser'       => 'slurm',
    'StoragePass'       => 'password',
  }

  case $::osfamily {
    'RedHat': {
      $db_client_file = '/etc/mysql/my.cnf'
      $dbbackup_enable = true
      $db_user = 'root'
    }
    'Debian': {
      $db_client_file = '/etc/mysql/debian.cnf'
      $db_backup_enable = true
      $db_user = 'debian-sys-maint'
    }
    default: {
      $db_backup_enable = false
      $db_user = 'root'
    }
  }

  $db_options_defaults = {
    'db' => {
      'hosts'    => 'localhost',
      'user'     => $db_user,
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

  $db_backup_options_defaults = {
    'BKDIR'                => '/var/backups/slurmdbd',
    'ACCTDB'               => 'slurm_acct_db',
    'DBMAINCONF'           => $db_client_file,
  }

  $sync_enable      = true
  $sync_conf_file   = '/etc/slurm-llnl/sync-accounts.conf'
  $sync_exec        = '/usr/sbin/slurm-sync-accounts'
  $sync_cron_user   = 'root'
  $sync_cron_hour   = 2
  $sync_cron_minute = 0
  $sync_pkg_cron    = '/etc/cron.d/slurm-llnl-sync-accounts'
  $sync_pkg_cron_ensure = absent

  $sync_options_defaults = {
    main => {
      org     => 'org',
      cluster => 'cluster',
      group   => 'users',
      policy  => 'global_account',
    },
    global_account => {
      name    => 'users',
      desc    => 'all users account',
    },
  }

  ### Package ###
  $packages_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $packages_manage = true
      $packages        = ['slurm-slurmdbd']
      $db_manage = false
    }
    'Debian': {
      $packages_manage = true
      $packages        = [
        'slurmdbd',
        'slurm-llnl-setup-mysql',
        'slurm-llnl-sync-accounts',
      ]
      # The DB can be managed automatically on debian thanks to a script
      # provided by slurm-llnl-setup-mysql package. It is not yet possible on
      # other distros.
      $db_manage = true
    }
    default: {
      $packages_manage = false
    }
  }
}
