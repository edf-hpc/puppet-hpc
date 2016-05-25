class slurmd::params {

  ### Service ###
  $service_enable   = true
  $service_ensure   = 'running'
  $service_manage   = true

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      if $::operatingsystemmajrelease < 7 {
        $service_name  = 'slurm'
      }
      else {
        $service_name  = 'slurmd'
      }
    }
    default: {
      $service_name  = 'slurmd'
    }
  }

  ### Configuration ###
  $config_manage         = true
  $bin_dir_path          = '/usr/lib/slurm'
  $conf_dir_path         = '/etc/slurm-llnl'
  $script_dir_path       = "${bin_dir_path}/generic-scripts"


  ### Cgroups ###
  $enable_cgroup          = true
  $cgroup_rel_path        = "${conf_dir_path}/cgroup"
  $cgroup_conf_file       = "${conf_dir_path}/cgroup.conf"
  $cgroup_relscript_file  = "${cgroup_rel_path}/release_common"
  $cgroup_relscript_src   = '/usr/share/doc/slurmd/examples/cgroup.release_common'
  $cgroup_rscpuset_file   = "${cgroup_rel_path}/release_cpuset"
  $cgroup_rs_freez_file   = "${cgroup_rel_path}/release_freezer"
  $cgroup_rs_mem_file     = "${cgroup_rel_path}/release_memory"
  $cgroup_options_default = {
    'CgroupAutomount' => {
       value   => 'yes',
       comment => 'Auto Mount',
     },
     'CgroupReleaseAgentDir' => {
       value   => $cgroup_rel_path,
       comment => 'Path of scripts to release cgroups',
     },
     'ConstrainCores' => {
       value   => 'no',
       comment => 'Core affinity',
     },
     'ConstrainRAMspace' => {
       value   => 'no',
       comment => 'Memory Usage',
     },
  }


  ### Custom scripts ###
  $tmp_create_file       = "${script_dir_path}/TaskProlog.d/tmp_create.sh"
  $tmp_create_src        = 'puppet:///modules/slurmd/tmp_create.sh'
  $tmp_remove_file       = "${script_dir_path}/TaskEpilog.d/tmp_remove.sh"
  $tmp_remove_src        = 'puppet:///modules/slurmd/tmp_remove.sh'


  ### Package ###
  $package_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $package_manage  =  true
      $package_name    = ['slurm', 'slurm-plugins']
    }
    'Debian': {
      $package_manage  =  true
      $package_name    = ['slurmd', 'slurm-wlm-basic-plugins']
    }
    default: {
      $package_manage  =  false
    }
  }
}
