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
# @param packaes          List of packages to install
class pam::slurm (
  $condition          = $pam::slurm::params::condition,
  $exec               = $pam::slurm::params::exec,
  $pamauthupdate_file = $pam::slurm::params::pamauthupdate_file,
  $packages_ensure    = $pam::slurm::params::packages_ensure,
  $packages           = $pam::slurm::params::packages,
) inherits pam::slurm::params {
  require ::pam

  validate_string($condition)
  validate_string($exec)
  validate_absolute_path($pamauthupdate_file)
  validate_string($packages_ensure)
  validate_array($packages)

  anchor { 'pam::slurm::begin': } ->
  class { '::pam::slurm::install': } ->
  class { '::pam::slurm::config': } ->
  anchor { 'pam::slurm::end': }

}
