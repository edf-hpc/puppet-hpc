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


# Load ipmi modules during boot
#
# Use the distribution method to automatically load a module on boot
#
# @param config_file Path of the file where the modules are added (
#           default: depends on the distribution)
# @param config_options Array listing the modules (default: depends on
#           the distribution)
# @param config_file_mode Default mode for `config_file`
# @param config_file_template Which template to use for `config_file`
# @param use_systemd_modules Should systemd::modules_load be used or
#          some other custom mechanism.
# @param modules_load_name Name of the modules-load.d file to override
# @param install_manage Public class manages the installation (default: true)
# @param packages_manage Public class installs the packages (default: true)
# @param packages List of packages for the IPMITool software
#          (default: ['ipmitool'])
# @param packages_ensure Target state for the packages (default: 'present')
class ipmi (
  $use_systemd_modules  = $::ipmi::params::use_systemd_modules,
  $modules_load_name    = $::ipmi::params::modules_load_name,
  $install_manage       = $::ipmi::params::install_manage,
  $packages_manage      = $::ipmi::params::packages_manage,
  $packages             = $::ipmi::params::packages,
  $packages_ensure      = $::ipmi::params::packages_ensure,
  $config_file          = $::ipmi::params::config_file,
  $config_options       = $::ipmi::params::config_options,
  $config_file_template = $::ipmi::params::config_file_template,
  $config_file_mode     = $::ipmi::params::config_file_mode,
) inherits ipmi::params {

  validate_array($config_options)
  validate_bool($install_manage)
  validate_bool($packages_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  validate_bool($use_systemd_modules)
  if $use_systemd_modules {
    validate_string($modules_load_name)
  } else {
    validate_absolute_path($config_file)
    validate_string($config_file_template)
    validate_string($config_file_mode)
  }

  anchor { 'ipmi::begin': } ->
  class { '::ipmi::install': } ->
  class { '::ipmi::config': } ->
  anchor { 'ipmi::end': }

}
