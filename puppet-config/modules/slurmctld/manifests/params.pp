class slurmctld::params {

  $enable_lua        = true
  $enable_topology   = true
  $enable_wckeys     = false

  ### Service ###
  $service_enable    = true
  $service_ensure    = 'running'
  $service_manage    = true
  $service_name      = 'slurmctld'


  ### Configuration ###
  $config_manage     = true
  $topo_conf_file    = "${slurmcommons::conf_dir_path}/topology.conf"
  $submit_lua_script = "${slurmcommons::conf_dir_path}/job_submit.lua"

  $topology_conf     = [
    'SwitchName=switch1 Nodes=localhost',
  ]



  ### Package & Configuration ###
  $package_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $package_manage    =  true
      $package_name      = ['slurm', 'slurm-devel']
      $submit_lua_source = 'puppet:///modules/slurmctld/job_submit.lua'
    }
    'Debian': {
      $package_manage    =  true
      $package_name      = ['slurmctld','slurm-llnl-job-submit-plugin']
      $submit_lua_source = "${slurmcommons::bin_dir_path}/job_submit.lua"
    }
    default: {
      $package_manage  =  false
    }
  }
}
