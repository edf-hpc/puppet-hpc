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

# Configure pam_pwquality: check password strength
#
# Only works on Debian
#
# @param packages_ensure  Ensures the packages are in this state (default:
#                         'present)
# @param packages         List of packages to install
# @param pamauthupdate_file Path of the file to be picked up by pam-auth-update
class pam::pwquality (
  $pamauthupdate_file = $pam::params::pwquality::pamauthupdate_file,
  $packages_ensure    = $pam::params::pwquality::packages_ensure,
  $packages           = $pam::params::pwquality::packages,
) inherits pam::pwquality::params {
  require ::pam

  validate_absolute_path($pamauthupdate_file)
  validate_string($packages_ensure)
  validate_array($packages)

  anchor { 'pam::pwquality::begin': } ->
  class { '::pam::pwquality::install': } ->
  class { '::pam::pwquality::config': } ->
  anchor { 'pam::pwquality::end': }

}
