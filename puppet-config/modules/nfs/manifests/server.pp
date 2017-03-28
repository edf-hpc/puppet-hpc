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
# @param service_manage    Boolean: true if puppet should manage the
#                          service state
# @param service           Name of the service
# @param exports_file Path of the exports file (default: '/etc/exports')
# @param default_file Path of the file for the default env settings
#          (default: '/etc/default/nfs-kernel-server')
# @param default_options Hash of values for the default_file content
class nfs::server (
  $exports_file    = $::nfs::server::params::exports_file,
  $packages        = $::nfs::server::params::packages,
  $packages_ensure = $::nfs::server::params::packages_ensure,
  $service_manage  = $::nfs::server::params::service_manage,
  $service         = $::nfs::server::params::service,
  $service_ensure  = $::nfs::server::params::service_ensure,
  $default_file    = $::nfs::server::params::default_file,
  $default_options = {},
) inherits nfs::server::params {
  require ::nfs

  validate_absolute_path($exports_file)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_bool($service_manage)
  validate_string($service)
  validate_string($service_ensure)
  validate_absolute_path($default_file)
  validate_hash($default_options)

  $_default_options = deep_merge($default_options_defaults, $default_options)

  anchor { 'nfs::server::begin': } ->
  class { '::nfs::server::install': } ->
  class { '::nfs::server::config': } ~>
  class { '::nfs::server::service': } ->
  anchor { 'nfs::server::end': }

}
