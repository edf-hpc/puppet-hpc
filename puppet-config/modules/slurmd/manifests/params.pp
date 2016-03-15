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

  ### Cgroups ###
  $enable_cgroup         = true
  $cgroup_rel_path       = "${slurmcommons::conf_dir_path}/cgroup"
  $cgroup_conf_file      = "${slurmcommons::conf_dir_path}/cgroup.conf"
  $cgroup_conf_tmpl      = 'slurm/cgroup_conf.erb'
  $cgroup_relscript_file = "${slurmcommons::cgroup_rel_path}/release_common"
  $cgroup_relscript_src  = '/usr/share/doc/slurmd/examples/cgroup.release_common'
  $cgroup_rscpuset_file  = "${slurmcommons::cgroup_rel_path}/release_cpuset"
  $cgroup_rs_freez_file  = "${slurmcommons::cgroup_rel_path}/release_freezer"
  $cgroup_rs_mem_file    = "${slurmcommons::cgroup_rel_path}/release_memory"

  ### Custom scripts ###
  $tmp_create_file       = "${slurmcommons::script_dir_path}/TaskProlog.d/tmp_create.sh"
  $tmp_create_src        = 'puppet:///modules/slurm/tmp_create.sh'
  $tmp_remove_file       = "${slurmcommons::script_dir_path}/TaskEpilog.d/tmp_remove.sh"
  $tmp_remove_src        = 'puppet:///modules/slurm/tmp_remove.sh'


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
