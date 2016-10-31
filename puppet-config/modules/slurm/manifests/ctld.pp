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

# Install the SLURM server (slurmctld)
#
# = Logging
#
# Logging is done to syslog by default. You can change it by adding the
# corresponding parameters to `::slurm::config_options`.
#
# = lua job submit plugin
#
# The lua job submit plugin (`${::slurm::config_dir}/job_submit.lua`) is
# configured if the parameter `enable_lua` is set to true. The content of
# the script is coming from the `files` directory on Redhat like
# distribution and from the package `slurm-llnl-submit-plugin` on Debian
# and derivative distributions.
#
# @param config_manage     Write the configuration files (default: true)
# @param enable_lua        Enable the lua job submit script
#                          (default: true)
# @param enable_wckeys     Enable the WCkeys check (NOT IMPLEMENTED)
# @param submit_lua_file   Destination path of the lua submit script
# @param submit_lua_source Source of the file, package on Debian and
#                          module on Redhat
# @param packages_manage   Let this class installs the packages
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `present`)
# @param packages          Array of packages names
# @param service_manage    Let this class run and enable disable the
#                          service (default: true)
# @param service_ensure    Ensure state of the service: `running` or
#                          `stopped` (default: running)
# @param service_enable    Service started at boot (default: true)
# @param service           Name of the service
class slurm::ctld (
  $config_manage     = $::slurm::ctld::params::config_manage,
  $enable_lua        = $::slurm::ctld::params::enable_lua,
  $enable_wckeys     = $::slurm::ctld::params::enable_wckeys,
  $submit_lua_file   = $::slurm::ctld::params::submit_lua_file,
  $submit_lua_source = $::slurm::ctld::params::submit_lua_source,
  $submit_lua_conf   = $::slurm::ctld::params::submit_lua_conf,
  $submit_lua_cores  = $::slurm::ctld::params::submit_lua_cores,
  $submit_qos_exec   = $::slurm::ctld::params::submit_qos_exec,
  $submit_qos_conf   = $::slurm::ctld::params::submit_qos_conf,
  $packages_manage   = $::slurm::ctld::params::packages_manage,
  $packages_ensure   = $::slurm::ctld::params::packages_ensure,
  $packages          = $::slurm::ctld::params::packages,
  $service_manage    = $::slurm::ctld::params::service_manage,
  $service_ensure    = $::slurm::ctld::params::service_ensure,
  $service_enable    = $::slurm::ctld::params::service_enable,
  $service           = $::slurm::ctld::params::service,
) inherits slurm::ctld::params {

  ### Validate params ###
  validate_bool($packages_manage)
  validate_bool($config_manage)
  validate_bool($service_manage)

  if $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $config_manage {
    validate_bool($enable_lua)
    if $enable_lua {
      validate_absolute_path($submit_lua_file)
      validate_string($submit_lua_source)
      validate_absolute_path($submit_lua_conf)
      validate_integer($submit_lua_cores)
      # Generate lua conf hash for print_config with
      # submit_lua_cores.
      $_submit_lua_options = {
        'CORES_PER_NODE' => "${submit_lua_cores}",
      }
      validate_absolute_path($submit_qos_exec)
      validate_absolute_path($submit_qos_conf)
    }
  }

  if $service_manage {
    validate_bool($service_enable)
    validate_string($service)
    validate_string($service_ensure)
  }

  anchor { 'slurm::ctld::begin': } ->
  class { '::slurm::ctld::install': } ->
  class { '::slurm::ctld::config': } ->
  class { '::slurm::ctld::service': } ->
  anchor { 'slurm::ctld::end': }
}
