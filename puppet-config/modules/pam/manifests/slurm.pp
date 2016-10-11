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

# Configure pam_slurm: only authorize users with a slurm job
#
# Only works on Debian
#
# @param packages_ensure  Ensures the packages are in this state (default:
#                         'present)
# @param packages         List of packages to install
class pam::slurm (
  $packages_manage    = $pam::slurm::params::packages_manage,
  $packages           = $pam::slurm::params::packages,
  $packages_ensure    = $pam::slurm::params::packages_ensure,
  $preseed            = $pam::slurm::params::preseed,
  $module_enable      = $pam::slurm::params::module_enable,
) inherits pam::slurm::params {
  require ::pam

  validate_bool($packages_manage)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($preseed)
  validate_bool($module_enable)

  anchor { 'pam::slurm::begin': } ->
  class { '::pam::slurm::install': } ->
  anchor { 'pam::slurm::end': }

}
