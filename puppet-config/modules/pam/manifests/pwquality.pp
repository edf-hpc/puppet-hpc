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

class pam::pwquality (
  $pam_pwquality_package        = $pam::params::pam_pwquality_package,
  $pam_pwquality_exec           = $pam::params::pam_pwquality_exec,
  $pam_pwquality_config         = $pam::params::pam_pwquality_config,
  $packages_ensure              = $pam::params::packages_ensure,
) inherits pam::params {

  validate_array($pam_pwquality_package)
  validate_string($pam_pwquality_exec)
  validate_absolute_path($pam_pwquality_config)
  validate_string($packages_ensure)

  anchor { 'pam::pwquality::begin': } ->
  class { '::pam::pwquality::install': } ->
  class { '::pam::pwquality::config': } ->
  anchor { 'pam::pwquality::end': }

}
