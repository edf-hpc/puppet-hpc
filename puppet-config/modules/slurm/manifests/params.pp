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

class slurm::params {

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
      $packages = [ 'slurm-client' ]
    }
    default: {
      $packages_manage = false
    }
  }

  ### Configuration ###
  $bin_dir         = '/usr/lib/slurm'
  $config_dir      = '/etc/slurm-llnl'
  $logs_dir        = '/var/log/slurm-llnl'
  $scripts_dir     = "${bin_dir}/generic-scripts"
  $config_file     = "${config_dir}/slurm.conf"
  $partitions_file = "${config_dir}/partitions.conf"

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

  $config_options_generic_scripts = {
    'Prolog'          => "${scripts_dir}/Prolog.sh",
    'PrologSlurmctld' => "${scripts_dir}/PrologSlurmctld.sh",
    'TaskProlog'      => "${scripts_dir}/TaskProlog.sh",
    'SrunProlog'      => "${scripts_dir}/SrunProlog.sh",
    'Epilog'          => "${scripts_dir}/Epilog.sh",
    'EpilogSlurmctld' => "${scripts_dir}/EpilogSlurmctld.sh",
    'TaskEpilog'      => "${scripts_dir}/TaskEpilog.sh",
    'SrunEpilog'      => "${scripts_dir}/SrunEpilog.sh",
  }

  $partitions_options = [
    'NodeName=localhost CPUs=1 State=UNKNOWN',
    'PartitionName=local Nodes=localhost Default=YES MaxTime=INFINITE State=UP',
  ]


}
