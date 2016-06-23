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
  $cgroup_options        = {},
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

  if $enable_cgroup {
    validate_absolute_path($cgroup_rel_path)
    validate_absolute_path($cgroup_conf_file)
    validate_string($cgroup_conf_tmpl)
    validate_absolute_path($cgroup_relscript_file)
    validate_string($cgroup_relscript_src)
    validate_absolute_path($cgroup_rscpuset_file)
    validate_absolute_path($cgroup_rs_freez_file)
    validate_absolute_path($cgroup_rs_mem_file)
    validate_hash($cgroup_options)

    $_cgroup_options = deep_merge($::slurmd::params::cgroup_options_default, $cgroup_options)
  }

  anchor { 'slurmd::begin': } ->
  class { '::slurmd::install': } ->
  class { '::slurmd::config': } ->
  class { '::slurmd::service': } ->
  anchor { 'slurmd::end': }
}
