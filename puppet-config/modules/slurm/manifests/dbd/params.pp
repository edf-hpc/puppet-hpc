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

class slurm::dbd::params {
  require ::slurm

  ### Service ###
  $service_enable = true
  $service_ensure = 'running'
  $service_manage = true
  $service_name   = 'slurmdbd'

  ### Configuration ###
  $config_manage  = true
  $config_file    = "${::slurm::config_dir}/slurmdbd.conf"

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

  ### Package ###
  $packages_ensure = 'present'
  case $::osfamily {
    'RedHat': {
      $packages_manage = true
      $packages        = ['slurm-slurmdbd']
    }
    'Debian': {
      $packages_manage = true
      $packages        = ['slurmdbd']
    }
    default: {
      $packages_manage = false
    }
  }
}
