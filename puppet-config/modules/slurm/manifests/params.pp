class slurm::params {

  $enable_daemon         = true
  $enable_ctld           = false
  $enable_client         = false
  $enable_lua            = true
  $enable_cgroup         = true
  $enable_conf           = true
  $enable_topology       = true

  ### Service ###
  $service_enable   = true
  $service_ensure   = 'running'
  $service_manage   = true

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      if $::operatingsystemmajrelease < 7 {
        $service_dmn_name  = 'slurm'
        $service_ctld_name = 'slurmctld'
      }
      else {
        $service_dmn_name  = 'slurmd'
        $service_ctld_name = 'slurmctld'
      }
    }
    default: {
      $service_dmn_name  = 'slurmd'
      $service_ctld_name = 'slurmctld'
    }
  }

  ### Configuration ###
  $bin_dir_path          = '/usr/lib/slurm'
  $conf_dir_path         = '/etc/slurm-llnl'
  $logs_dir_path         = '/var/log/slurm-llnl'
  $script_dir_path       = "${bin_dir_path}/generic-scripts"
  $main_conf_file        = "${conf_dir_path}/slurm.conf"
  $part_conf_file        = "${conf_dir_path}/partitions.conf"
  $part_conf_tmpl        = 'slurm/partitions_conf.erb'
  $topo_conf_file        = "${conf_dir_path}/topology.conf"
  $jobsc_ctl_lua         = "${bin_dir_path}/job_submit.lua"

  ### Cgroups ###
  $cgroup_rel_path       = "${conf_dir_path}/cgroup"
  $cgroup_conf_file      = "${conf_dir_path}/cgroup.conf"
  $cgroup_conf_tmpl      = 'slurm/cgroup_conf.erb'
  $cgroup_relscript_file = "${cgroup_rel_path}/release_common"
  $cgroup_relscript_src  = '/usr/share/doc/slurmd/examples/cgroup.release_common'
  $cgroup_rscpuset_file  = "${cgroup_rel_path}/release_cpuset"
  $cgroup_rs_freez_file  = "${cgroup_rel_path}/release_freezer"
  $cgroup_rs_mem_file    = "${cgroup_rel_path}/release_memory"

  ### Custom scripts ###
  $tmp_create_file       = "${script_dir_path}/TaskProlog.d/tmp_create.sh"
  $tmp_create_src        = 'puppet:///modules/slurm/tmp_create.sh'
  $tmp_remove_file       = "${script_dir_path}/TaskEpilog.d/tmp_remove.sh"
  $tmp_remove_src        = 'puppet:///modules/slurm/tmp_remove.sh'


  ### Options ###
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
  $topology_conf = [
    'SwitchName=switch1 Nodes=localhost',
  ]



  ### Package ###
  $package_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $package_manage      =  true
      $package_ctld_name   = ['slurm', 'slurm-devel']
      $package_dmn_name    = ['slurm', 'slurm-plugins']
      $package_client_name = ['slurm-sview']
    }
    'Debian': {
      $package_manage      =  true
      $package_ctld_name   = ['slurmctld','slurm-llnl-job-submit-plugin']
      $package_dmn_name    = ['slurmd', 'slurm-wlm-basic-plugins']
      $package_client_name = ['sview']
    }
    default: {
      $package_manage    =  false
    }
  }
}
