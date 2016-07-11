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

# NFS client
#
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `present`)
# @param packages          Array of packages names
# @param service_ensure    Ensure state of the service: `running` or
#                          `stopped` (default: running)
# @param service           Name of the service
class nfs::client (
  $packages        = $::nfs::client::params::packages,
  $packages_ensure = $::nfs::client::params::packages_ensure,
  $service         = $::nfs::client::params::service,
  $service_ensure  = $::nfs::client::params::service_ensure,
) inherits nfs::client::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)

  anchor { 'nfs::client::begin': } ->
  class { '::nfs::client::install': } ->
  class { '::nfs::client::service': } ->
  anchor { 'nfs::client::end': }

}
