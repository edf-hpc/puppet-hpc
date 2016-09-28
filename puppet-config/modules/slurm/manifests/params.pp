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
  ### Configuration ###
  $bin_dir         = '/usr/lib/slurm'
  $config_dir      = '/etc/slurm-llnl'
  $logs_dir        = '/var/log/slurm-llnl'
  $scripts_dir     = "${bin_dir}/generic-scripts"
  $config_file     = "${config_dir}/slurm.conf"
  $partitions_file = "${config_dir}/partitions.conf"

  $enable_generic_scripts = true

  $config_options_defaults = {
    'ClusterName' => {
      value   => 'mycluster',
      comment => 'The name by which this SLURM managed cluster is known in the accounting database',
    },
    'ControlMachine' => {
      value   => 'localhost',
      comment => 'Hostname of the machine where SLURM control functions are executed',
    },
    'SlurmUser' => {
      value   => 'slurm',
      comment => 'The name of the user that the slurmctld daemon executes as',
    },
    'SlurmctldPort' => {
      value   => '6817',
      comment => 'The port number that the SLURM controller, slurmctld, listens to for work',
    },
    'SlurmdPort' => {
      value   => '6818',
      comment => 'The port number that the SLURM compute node daemon, slurmd, listens to for work. SlurmctldPort and SlurmdPort must be different',
    },
    'SlurmctldPidFile' => {
      value   => '/var/run/slurm-llnl/slurmctld.pid',
      comment => 'File into which the slurmctld daemon may write its process id',
    },
    'SlurmdPidFile' => {
      value   => '/var/run/slurm-llnl/slurmd.pid',
      comment => 'File into which the slurmd daemon may write its process id',
    },
    'SlurmdSpoolDir' => {
      value   => '/var/spool/slurmd',
      comment => 'Directory (local file system) into which the slurmd daemons state information and batch job script information are written',
    },
    'AuthType' => {
      value   => 'auth/munge',
      comment => 'The authentication method for communications between SLURM components',
    },
    'CryptoType' => {
      value   => 'crypto/munge',
      comment => 'The cryptographic signature tool to be used in the creation of job step credentials',
    },
    'Include' => {
      'value'   => $partitions_file,
      'comment' => 'If a line begins with the word \'Include\' followed by whitespace and then a file name, that file will be included inline with the current configuration file',
    },
  }

  $config_options_generic_scripts = {
    'Prolog' => {
      'value'   => "${scripts_dir}/Prolog.sh",
      'comment' => 'Script executed at job step initiation on that node',
    },
    'PrologSlurmctld' => {
      'value'   => "${scripts_dir}/PrologSlurmctld.sh",
      'comment' => 'Script executed at job allocation',
    },
    'TaskProlog' => {
      'value'  => "${scripts_dir}/TaskProlog.sh",
      'comment'=> 'Script executed at job step initiation by user invoking srun command',
    },
    'SrunProlog' => {
      'value'   => "${scripts_dir}/SrunProlog.sh",
      'comment' => 'Script executed at job step initiation by user invoking sbatch command',
    },
    'Epilog' => {
      'value'   =>"${scripts_dir}/Epilog.sh",
      'comment' => 'Script executed at job termination',
    },
    'EpilogSlurmctld' => {
      'value'   => "${scripts_dir}/EpilogSlurmctld.sh",
      'comment' => 'Script executed at job termination by',
    },
    'TaskEpilog' => {
      'value'   => "${scripts_dir}/TaskEpilog.sh",
      'comment' => 'Script executed at completion job step by user invoking sbatch command',
    },
    'SrunEpilog' => {
      'value'   => "${scripts_dir}/SrunEpilog.sh",
      'comment' => 'Script executed at completion job step by user invoking srun command',
    },
  }

  $partitions_options = [
    'NodeName=localhost CPUs=1 State=UNKNOWN',
    'PartitionName=local Nodes=localhost Default=YES MaxTime=INFINITE State=UP',
  ]


}
