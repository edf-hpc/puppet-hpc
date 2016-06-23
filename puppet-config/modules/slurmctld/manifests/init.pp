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

class slurmctld (
  $config_manage     = $slurmctld::params::config_manage,
  $enable_topology   = $slurmctld::params::enable_topology,
  $enable_lua        = $slurmctld::params::enable_lua,
  $enable_wckeys     = $slurmctld::params::enable_wckeys,
  $topo_conf_file    = $slurmctld::params::topo_conf_file,
  $submit_lua_script = $slurmctld::params::submit_lua_script,
  $submit_lua_source = $slurmctld::params::submit_lua_source,
  $jobsc_ctl_lua     = $slurmctld::params::jobsc_ctl_lua,
  $topology_conf     = $slurmctld::params::topology_conf,
  $package_manage    = $slurmctld::params::package_manage,
  $package_ensure    = $slurmctld::params::package_ensure,
  $package_name      = $slurmctld::params::package_name,
  $service_manage    = $slurmctld::params::service_manage,
  $service_ensure    = $slurmctld::params::service_ensure,
  $service_enable    = $slurmctld::params::service_enable,
  $service_name      = $slurmctld::params::service_name,
) inherits slurmctld::params {



  ### Validate params ###
  validate_bool($package_manage)
  validate_bool($config_manage)
  validate_bool($service_manage)

  if $package_manage {
    validate_array($package_name)
    validate_string($package_ensure)
  }

  if $config_manage {
    validate_bool($enable_topology)
    validate_bool($enable_lua)
    validate_absolute_path($topo_conf_file)
    if $enable_lua {
      validate_absolute_path($submit_lua_script)
      validate_string($submit_lua_source)
    }
    if $enable_topology { validate_array($topology_conf) }
  }

  if $service_manage {
    validate_bool($service_enable)
    validate_string($service_name)
    validate_string($service_ensure)
  }

  anchor { 'slurmctld::begin': } ->
  class { '::slurmctld::install': } ->
  class { '::slurmctld::config': } ->
  class { '::slurmctld::service': } ->
  anchor { 'slurmctld::end': }
}
