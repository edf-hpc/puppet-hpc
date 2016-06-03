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

class nfs_client (
  $packages        = $::nfs_client::params::packages, 
  $packages_ensure = $::nfs_client::params::packages_ensure, 
  $service         = $::nfs_client::params::service,
  $service_ensure  = $::nfs_client::params::service_ensure,
) inherits nfs_client::params {
  
  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)

  anchor { 'nfs_client::begin': } ->
  class { 'nfs_client::install': } ->
  class { 'nfs_client::service': } ->
  anchor { 'nfs_client::end': }

} 
