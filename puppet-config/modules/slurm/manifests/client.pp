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

# Install slurm clients (CLI and sview)
#
# @param packages_manage   Let this class installs the packages
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `present`)
# @param packages          Array of packages names
class slurm::client (
  $packages_manage = $::slurm::client::params::packages_manage,
  $packages_ensure = $::slurm::client::params::packages_ensure,
  $packages        = $::slurm::client::params::packages,
) inherits slurm::client::params {

  validate_bool($packages_manage)
  if $packages_manage {
    validate_string($packages_ensure)
    validate_array($packages)
  }

  anchor { 'slurm::client::begin': } ->
  class { '::slurm::client::install': } ->
  class { '::slurm::client::config': } ->
  anchor { 'slurm::client::end': }
}
