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

class nfs_server (
  $exports_file    = $::nfs_server::params::exports_file,
  $packages        = $::nfs_server::params::packages,
  $packages_ensure = $::nfs_server::params::packages_ensure,
  $service         = $::nfs_server::params::service,
  $service_ensure  = $::nfs_server::params::service_ensure,
) inherits nfs_server::params {

  validate_absolute_path($exports_file)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)

  anchor { 'nfs_server::begin': } ->
  class { 'nfs_server::install': } ->
  class { 'nfs_server::service': } ->
  anchor { 'nfs_server::end': }

}
