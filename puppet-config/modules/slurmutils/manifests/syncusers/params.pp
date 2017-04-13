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

class slurmutils::syncusers::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['slurm-llnl-sync-accounts']
  $packages_ensure = 'latest'
  $pkg_cron_file   = '/etc/cron.d/slurm-llnl-sync-accounts'
  $pkg_cron_ensure = 'absent'

  $config_manage   = true
  $conf_file       = '/etc/slurm-llnl/sync-accounts.conf'

  $conf_options_defaults = {
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

  $cron_exec = '/usr/sbin/slurm-sync-accounts'
  $cron_user = 'root'

  # On second node, run at 1pm. On other node (probably 1st node), run at 1am.
  if $::hostname =~ /.*2$/ {
   $cron_hour = 13
  } else {
   $cron_hour = 1
  }
  $cron_minute = 0

}
