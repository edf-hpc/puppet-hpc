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

# Configure pam_limits
#
# The class will configure `/etc/security/limits.conf` and _only on
# Debian_ activate the pam_limits module.
#
# @param config_file    Path of the configuration file for pam_access
#                       (default: `/etc/security/limits.conf`)
# @param config_options Content of the pam_limits config file as a hash
#                       of key -> lines (default: {})
# @param type           Pam type (default: 'session')
# @param module         Pam module name (default: 'pam_limits.so')
# @param control        Pam control (default: 'required')
# @param position       Position of the module inside the file (default:
#                       after the comment "end of pam-auth-update
#                       config")
# @param pam_service    Pam service name (default: 'common-session')
class pam::limits (
  $pam_service    = $pam::limits::params::pam_service,
  $module         = $pam::limits::params::module,
  $control        = $pam::limits::params::control,
  $type           = $pam::limits::params::type,
  $position       = $pam::limits::params::position,
  $config_file    = $pam::limits::params::config_file,
  $config_options = $pam::limits::params::config_options,
) inherits pam::limits::params {
  require ::pam

  validate_absolute_path($config_file)
  validate_hash($config_options)
  validate_string($pam_service)
  validate_string($module)
  validate_string($type)
  validate_string($control)
  validate_string($position)

  anchor { 'pam::limits::begin': } ->
  class { '::pam::limits::config': } ->
  anchor { 'pam::limits::end': }
}
