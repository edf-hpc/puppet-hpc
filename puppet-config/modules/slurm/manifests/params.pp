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

class slurm::params {

  $enable_topology = true

  ### Package ###
  $packages_ensure = 'present'
  case $::osfamily {
    'RedHat': {
      $packages_manage = true
      # The slurm RPM package provides all client and daemons binaries.
      $packages = ['slurm']
    }
    'Debian': {
      $packages_manage = true
      $packages = ['slurm-client']
    }
    default: {
      $packages_manage = false
    }
  }

  $spank_plugins = {}
  $spank_pkg_prefix = 'slurm-wlm-spank-plugin-'

  ### Configuration ###
  $config_dir      = '/etc/slurm-llnl'
  $config_file     = "${config_dir}/slurm.conf"
  $partitions_file = "${config_dir}/partitions.conf"
  $gres_file       = "${config_dir}/gres.conf"
  $spank_conf_dir  = "${config_dir}/plugstack.conf.d"
  $topology_file   = "${config_dir}/topology.conf"
  $topology_options = [
    'SwitchName=switch1 Nodes=localhost',
  ]

  $enable_generic_scripts = true

  $config_options_defaults = {
    'ClusterName'      => 'mycluster',
    'ControlMachine'   => 'localhost',
    'SlurmUser'        => 'slurm',
    'SlurmctldPidFile' => '/var/run/slurm-llnl/slurmctld.pid',
    'SlurmdPidFile'    => '/var/run/slurm-llnl/slurmd.pid',
    'AuthType'         => 'auth/munge',
    'CryptoType'       => 'crypto/munge',
    'Include'          => $partitions_file,
  }

  $partitions_options = [
    'NodeName=localhost CPUs=1 State=UNKNOWN',
    'PartitionName=local Nodes=localhost Default=YES MaxTime=INFINITE State=UP',
  ]

}
