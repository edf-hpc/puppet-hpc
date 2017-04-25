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

# Deploys Mellanox FCA software on FCA managers
#
# @param install_manage Public class manages the installation (default: true)
# @param packages_manage Public class installs the packages (default: true)
# @param packages List of packages for the OpenSM software (default: ['fca'])
# @param packages_ensure Target state for the packages (default: 'present')
# @param service_manage Public class manages the service state (default: true)
# @param service_name Name of the service to manage (default: 'fca')
# @param service_ensure Target state for the service (default: 'running')
# @param service_enable The service starts at boot time (default: true)
class fca (
  $install_manage          = $::fca::params::install_manage,
  $packages_manage         = $::fca::params::packages_manage,
  $packages                = $::fca::params::packages,
  $packages_ensure         = $::fca::params::packages_ensure,
  $service_manage          = $::fca::params::service_manage,
  $service_name            = $::fca::params::service_name,
  $service_ensure          = $::fca::params::service_ensure,
  $service_enable          = $::fca::params::service_enable,
) inherits fca::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($service_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $service_manage {
    validate_string($service_name)
    validate_string($service_ensure)
    validate_bool($service_enable)
  }

  anchor { 'fca::begin': } ->
  class { '::fca::install': } ->
  class { '::fca::service': } ->
  anchor { 'fca::end': }

}
