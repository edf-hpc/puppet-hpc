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

# Configure pam_sss: pam<-->sssd integration
#
# Only works on Debian
#
# @param packages_ensure  Ensures the packages are in this state (default:
#                         'present)
# @param packages         List of packages to install
class pam::sss (
  $packages_ensure = $pam::sss::params::packages_ensure,
  $packages        = $pam::sss::params::packages,
) inherits pam::sss::params {
  require ::pam

  validate_string($packages_ensure)
  validate_array($packages)

  anchor { 'pam::sss::begin': } ->
  class { '::pam::sss::install': } ->
  anchor { 'pam::sss::end': }

}
