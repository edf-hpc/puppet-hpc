class slurm (
  $enable_conf           = $slurm::params::enable_conf,
  $enable_cgroup         = $slurm::params::enable_cgroup,
  $enable_topology       = $slurm::params::enable_topology,
  $bin_dir_path          = $slurm::params::bin_dir_path,
  $conf_dir_path         = $slurm::params::conf_dir_path,
  $logs_dir_path         = $slurm::params::logs_dir_path,
  $script_dir_path       = $slurm::params::script_dir_path,
  $main_conf_file        = $slurm::params::main_conf_file,
  $part_conf_file        = $slurm::params::part_conf_file,
  $part_conf_tmpl        = $slurm::params::part_conf_tmpl,
  $topo_conf_file        = $slurm::params::topo_conf_file,
  $jobsc_ctl_lua         = $slurm::params::jobsc_ctl_lua,
  $cgroup_rel_path       = $slurm::params::cgroup_rel_path,
  $cgroup_conf_file      = $slurm::params::cgroup_conf_file,
  $cgroup_conf_tmpl      = $slurm::params::cgroup_conf_tmpl,
  $cgroup_relscript_file = $slurm::params::cgroup_relscript_file,
  $cgroup_relscript_src  = $slurm::params::cgroup_relscript_src,
  $cgroup_rscpuset_file  = $slurm::params::cgroup_rscpuset_file,
  $cgroup_rs_freez_file  = $slurm::params::cgroup_rs_freez_file,
  $cgroup_rs_mem_file    = $slurm::params::cgroup_rs_mem_file,
  $slurm_conf_options    = $slurm::params::slurm_conf_options,
  $partitions_conf       = $slurm::params::partitions_conf,
  $topology_conf         = $slurm::params::topology_conf,
  $package_manage        = $slurm::params::package_manage,
  $package_ensure        = $slurm::params::package_ensure,
  $package_ctld_name     = $slurm::params::package_ctld_name,
  $package_dmn_name      = $slurm::params::package_dmn_name,
  $package_client_name   = $slurm::params::package_client_name,
  $service_manage        = $slurm::params::service_manage,
  $service_ensure        = $slurm::params::service_ensure,
  $service_enable        = $slurm::params::service_enable,
  $service_dmn_name      = $slurm::params::service_dmn_name,
) inherits slurm::params {

  ### Validate params ###
  validate_bool($enable_conf)
  validate_bool($enable_cgroup)
  if $enable_conf {
    validate_bool($enable_topology)
    validate_absolute_path($bin_dir_path)
    validate_absolute_path($conf_dir_path)
    validate_absolute_path($logs_dir_path)
    validate_absolute_path($script_dir_path)
    validate_absolute_path($main_conf_file)
    validate_absolute_path($part_conf_file)
    validate_string($part_conf_tmpl)
    validate_absolute_path($topo_conf_file)
    validate_absolute_path($jobsc_ctl_lua)
    validate_hash($slurm_conf_options)
    validate_array($partitions_conf)
    if $enable_topology { validate_array($topology_conf) }
  }

  if $enable_cgroup {
    validate_absolute_path($cgroup_rel_path)
    validate_absolute_path($cgroup_conf_file)
    validate_string($cgroup_conf_tmpl)
    validate_absolute_path($cgroup_relscript_file)
    validate_string($cgroup_relscript_src)
    validate_absolute_path($cgroup_rscpuset_file)
    validate_absolute_path($cgroup_rs_freez_file)
    validate_absolute_path($cgroup_rs_mem_file)
  }

  anchor { 'slurm::begin': } ->
  class { '::slurm::install': } ->
  class { '::slurm::config': } ->
  class { '::slurm::service': } ->
  anchor { 'slurm::end': }
}
