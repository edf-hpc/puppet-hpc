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

class pam::slurm (
  $packages_ensure           = $pam::params::packages_ensure,
  $pam_slurm_package         = $pam::params::pam_slurm_package,
  $pam_slurm_config          = $pam::params::pam_slurm_config,
  $pam_slurm_exec            = $pam::params::pam_slurm_exec,
  $pam_slurm_condition       = $pam::params::pam_slurm_condition,
) inherits pam::params {
   
  validate_string($packages_ensure)
  validate_array($pam_slurm_package)
  validate_absolute_path($pam_slurm_config)
  validate_string($pam_slurm_exec)
  validate_string($pam_slurm_condition)

  anchor { 'pam::slurm::begin': } ->
  class { '::pam::slurm::install': } -> 
  class { '::pam::slurm::config': } ->
  anchor { 'pam::slurm::end': }

}
