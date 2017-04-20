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

# Deploys Mellanox FCA libraries
#
# @param install_manage Public class manages the installation (default: true)
# @param packages_manage Public class installs the packages (default: true)
# @param packages List of packages for the OpenSM software (default: ['fca'])
# @param packages_ensure Target state for the packages (default: 'present')
class fca (
  $install_manage          = $::fca::params::install_manage,
  $packages_manage         = $::fca::params::packages_manage,
  $packages                = $::fca::params::packages,
  $packages_ensure         = $::fca::params::packages_ensure,
) inherits fca::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  anchor { 'fca::begin': } ->
  class { '::fca::install': } ->
  anchor { 'fca::end': }

}
