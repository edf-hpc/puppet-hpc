##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2017 EDF S.A.                                      #
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

# Install the slurm compute node execution daemon (slurmd)
#
# = Logging
#
# Logging is done to syslog by default. You can change it by adding the
# corresponding parameters to `::slurm::config_options`.
#
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
class slurm::exec (
  $config_manage            = $::slurm::exec::params::config_manage,
  $enable_cgroup            = $::slurm::exec::params::enable_cgroup,
  $cgroup_file              = $::slurm::exec::params::cgroup_file,
  $cgroup_options           = {},
  $packages_manage          = $::slurm::exec::params::packages_manage,
  $packages_ensure          = $::slurm::exec::params::packages_ensure,
  $packages                 = $::slurm::exec::params::packages,
  $service_manage           = $::slurm::exec::params::service_manage,
  $service_ensure           = $::slurm::exec::params::service_ensure,
  $service_enable           = $::slurm::exec::params::service_enable,
  $service                  = $::slurm::exec::params::service,
) inherits slurm::exec::params {

  ### Validate params ###
  validate_bool($config_manage)
  validate_bool($enable_cgroup)
  validate_bool($service_manage)
  validate_bool($service_enable)
  validate_string($service)
  validate_bool($packages_manage)
  validate_string($packages_ensure)
  validate_array($packages)



  if $enable_cgroup {
    validate_absolute_path($cgroup_file)
    validate_hash($cgroup_options)

    $_cgroup_options = deep_merge($::slurm::exec::params::cgroup_options_defaults, $cgroup_options)
  }

  anchor { 'slurm::exec::begin': } ->
  class { '::slurm::exec::install': } ->
  class { '::slurm::exec::config': } ->
  class { '::slurm::exec::service': } ->
  anchor { 'slurm::exec::end': }
}
