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

class slurmutils::backupdb::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['slurmdbd-backup']
  $packages_ensure = 'latest'

  $config_manage   = true
  $conf_file       = '/etc/slurm-llnl/slurmdbd-backup.vars'

  $conf_options_defaults = {
    'BKDIR'      => '/var/backups/slurmdbd',
    'ACCTDB'     => 'slurm_acct_db',
    'DBMAINCONF' => '/etc/mysql/debian.cnf',
    'KEEP_OLD'   => 'false',
  }

  $cron_exec = '/usr/sbin/slurmdbd-backup'
  $cron_user = 'root'

  # On second node, run at 2pm. On other node (probably 1st node), run at 2am.
  if $::hostname =~ /.*2$/ {
   $cron_hour = 14
  } else {
   $cron_hour = 2
  }
  $cron_minute = 0

}
