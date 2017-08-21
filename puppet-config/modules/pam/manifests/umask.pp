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

# Configure pam_umask
#
# Only works on debian
#
# @param type           Pam type (default: 'session')
# @param module         Pam module name (default: 'pam_umask.so')
# @param control        Pam control (default: 'required')
# @param position       Position of the module inside the file (default:
#                       after the comment "account required
#                       pam_umask.so")
# @param pam_service    Pam service name (default: 'common-session')
class pam::umask (
  $type            = $pam::umask::params::type,
  $module          = $pam::umask::params::module,
  $control         = $pam::umask::params::control,
  $position        = $pam::umask::params::position,
  $pam_service     = $pam::umask::params::pam_service
) inherits pam::umask::params {
  require ::pam

  validate_string($type)
  validate_string($module)
  validate_string($control)
  validate_string($position)
  validate_string($pam_service)

  anchor { 'pam::umask::begin': } ->
  class { '::pam::umask::config': } ->
  anchor { 'pam::umask::end': }

}
