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

# Install the SLURM controller (slurmctld)
#
# @param packages_manage   Let this class installs the packages
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `present`)
# @param packages          Array of packages names
# @param service_manage    Let this class run and enable disable the
#                          service (default: true)
# @param service_ensure    Ensure state of the service: `running` or
#                          `stopped` (default: running)
# @param service_enable    Service started at boot (default: true)
# @param service           Name of the service
class slurm::ctld (
  $packages_manage    = $::slurm::ctld::params::packages_manage,
  $packages_ensure    = $::slurm::ctld::params::packages_ensure,
  $packages           = $::slurm::ctld::params::packages,
  $service_manage     = $::slurm::ctld::params::service_manage,
  $service_ensure     = $::slurm::ctld::params::service_ensure,
  $service_enable     = $::slurm::ctld::params::service_enable,
  $service            = $::slurm::ctld::params::service,
) inherits slurm::ctld::params {

  ### Validate params ###
  validate_bool($packages_manage)
  validate_bool($service_manage)

  if $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $service_manage {
    validate_bool($service_enable)
    validate_string($service)
    validate_string($service_ensure)
  }

  anchor { 'slurm::ctld::begin': } ->
  class { '::slurm::ctld::install': } ->
  class { '::slurm::ctld::service': } ->
  anchor { 'slurm::ctld::end': }
}
