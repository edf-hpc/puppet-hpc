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
  $conf_dir_path     = '/etc/slurm-llnl'
  $topo_conf_file    = "${conf_dir_path}/topology.conf"
  $submit_lua_script = "${conf_dir_path}/job_submit.lua"

  $topology_conf     = [
    'SwitchName=switch1 Nodes=localhost',
  ]

  ### Package & Configuration ###
  $package_ensure    = 'present'
  $submit_lua_source = 'puppet:///modules/slurmctld/job_submit.lua'
  case $::osfamily {
    'RedHat': {
      $package_manage    =  true
      $package_name      = [
        'slurm', 
        'slurm-devel',
      ]
    }
    'Debian': {
      $package_manage    =  true
      $package_name      = [
        'slurmctld',
        'slurm-llnl-job-submit-plugin',
      ]
    }
    default: {
      $package_manage  =  false
    }
  }
}
