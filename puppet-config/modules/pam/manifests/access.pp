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

# Configure pam_access
#
# The `exec` parameter is only used on Redhat. The parameters `type`,
# `module`, `control`, `position` and `pam_service` are only used on
# Debian.
#
# @param config_file    Path of the configuration file for pam_access
#                       (default: `/etc/security/access.conf`)
# @param config_options Content of the pam_access config file as an array
#                       of lines (default: [])
# @param exec           Command to execute, to activate the module
# @param type           Pam type (default: 'account')
# @param module         Pam module name (default: 'pam_access.so')
# @param control        Pam control (default: 'required')
# @param position       Position of the module inside the file (default:
#                       after the comment "account required
#                       pam_access.so")
# @param pam_service    Pam service name (default: 'sshd')
class pam::access (
  $config_file     = $pam::access::params::config_file,
  $config_options  = $pam::access::params::config_options,
  $exec            = $pam::access::params::exec,
  $type            = $pam::access::params::type,
  $module          = $pam::access::params::module,
  $control         = $pam::access::params::control,
  $position        = $pam::access::params::position,
  $pam_service     = $pam::access::params::pam_service
) inherits pam::access::params {
  require ::pam

  validate_absolute_path($config_file)
  validate_array($config_options)
  validate_string($exec)

  anchor { 'pam::access::begin': } ->
  class { '::pam::access::config': } ->
  anchor { 'pam::access::end': }

}
