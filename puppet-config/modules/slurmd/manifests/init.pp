class slurmd (
  $config_manage         = $slurmd::params::config_manage,
  $enable_cgroup         = $slurmd::params::enable_cgroup,
  $cgroup_rel_path       = $slurmd::params::cgroup_rel_path,
  $cgroup_conf_file      = $slurmd::params::cgroup_conf_file,
  $cgroup_conf_tmpl      = $slurmd::params::cgroup_conf_tmpl,
  $cgroup_relscript_file = $slurmd::params::cgroup_relscript_file,
  $cgroup_relscript_src  = $slurmd::params::cgroup_relscript_src,
  $cgroup_rscpuset_file  = $slurmd::params::cgroup_rscpuset_file,
  $cgroup_rs_freez_file  = $slurmd::params::cgroup_rs_freez_file,
  $cgroup_rs_mem_file    = $slurmd::params::cgroup_rs_mem_file,
  $package_manage        = $slurmd::params::package_manage,
  $package_ensure        = $slurmd::params::package_ensure,
  $package_name          = $slurmd::params::package_name,
  $service_manage        = $slurmd::params::service_manage,
  $service_ensure        = $slurmd::params::service_ensure,
  $service_enable        = $slurmd::params::service_enable,
  $service_name          = $slurmd::params::service_name,
) inherits slurmd::params {

  ### Validate params ###
  validate_bool($config_manage)
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

  anchor { 'slurmd::begin': } ->
  class { '::slurmd::install': } ->
  class { '::slurmd::config': } ->
  class { '::slurmd::service': } ->
  anchor { 'slurmd::end': }
}
