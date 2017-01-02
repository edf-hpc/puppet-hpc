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

# NFS server
#
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `present`)
# @param packages          Array of packages names
# @param service_ensure    Ensure state of the service: `running` or
#                          `stopped` (default: running)
# @param service           Name of the service
# @param exports_file Path of the exports file (default: '/etc/exports')
class nfs::server (
  $exports_file    = $::nfs::server::params::exports_file,
  $packages        = $::nfs::server::params::packages,
  $packages_ensure = $::nfs::server::params::packages_ensure,
  $service         = $::nfs::server::params::service,
  $service_ensure  = $::nfs::server::params::service_ensure,
) inherits nfs::server::params {
  require ::nfs

  validate_absolute_path($exports_file)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)

  anchor { 'nfs::server::begin': } ->
  class { '::nfs::server::install': } ->
  class { '::nfs::server::config': } ~>
  class { '::nfs::server::service': } ->
  anchor { 'nfs::server::end': }

}
