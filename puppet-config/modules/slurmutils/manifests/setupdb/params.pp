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

class slurmutils::setupdb::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['slurm-llnl-setup-mysql']
  $packages_ensure = 'latest'

  $config_manage   = true
  $conf_file       = '/etc/slurm-llnl/slurm-mysql.conf'

  $conf_options_defaults = {
    'db' => {
      'hosts'    => 'localhost',
      'user'     => 'debian-sys-maint',
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

  $exec_file = '/usr/sbin/slurm-mysql-setup'

}
