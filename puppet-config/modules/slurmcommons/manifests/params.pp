class slurmcommons::params {
  ### Configuration ###
  $bin_dir_path          = '/usr/lib/slurm'
  $conf_dir_path         = '/etc/slurm-llnl'
  $logs_dir_path         = '/var/log/slurm-llnl'
  $script_dir_path       = "${bin_dir_path}/generic-scripts"
  $main_conf_file        = "${conf_dir_path}/slurm.conf"
  $part_conf_file        = "${conf_dir_path}/partitions.conf"
  $slurm_conf_options = {
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
  }

  $partitions_conf = [
    'NodeName=localhost CPUs=1 State=UNKNOWN',
    'PartitionName=local Nodes=localhost Default=YES MaxTime=INFINITE State=UP',
  ]


}
