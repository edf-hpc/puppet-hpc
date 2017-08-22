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

# NFS common
#
#
# @param idmapd_options    Content of the idampd configuration file
# @param idmapd_file       Path of the idmapd configuration file
# @param default_options   Content of the default (syscfg) file parameter
#         for the nfs-common service
# @param default_file      Path of the default (syscfg) file parameter
#         for the nfs-common service (default: '/etc/default/nfs-common')
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `present`)
# @param packages          Array of packages names
# @param service_ensure    Ensure state of the service: `running` or
#                          `stopped` (default: running)
# @param service           Name of the service
# @param enable_gssd       Enable gss daemon with the nfs service
# @param disable_rpcbind   Boolean to stop and disable rpcbind service (default:
#                          true)
# @param service_rpcbind   Name of the rpcbind service (default: 'rpcbind')
class nfs (
  $idmapd_options  = {},
  $idmapd_file     = $::nfs::params::idmapd_file,
  $default_options = {},
  $default_file    = $::nfs::params::default_file,
  $service_ensure  = $::nfs::params::service_ensure,
  $service         = $::nfs::params::service,
  $enable_gssd     = $::nfs::params::enable_gssd,
  $disable_rpcbind = $::nfs::params::disable_rpcbind,
  $service_rpcbind = $::nfs::params::service_rpcbind,
  $packages_ensure = $::nfs::params::packages_ensure,
  $packages        = $::nfs::params::packages,
) inherits ::nfs::params {
  validate_absolute_path($idmapd_file)
  validate_hash($idmapd_options)
  validate_absolute_path($default_file)
  validate_hash($default_options)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($enable_gssd)
  validate_bool($disable_rpcbind)
  validate_string($service_rpcbind)

  $_idmapd_options = deep_merge($::nfs::params::idmapd_options_defaults, $idmapd_options)

  if $enable_gssd {
    $gssd_options = { 'NEED_GSSD' => 'yes', }
  } else {
    $gssd_options = {}
  }
  $tmp_default_options = deep_merge($::nfs::params::default_options_defaults, $gssd_options)
  $_default_options = deep_merge($tmp_default_options, $default_options)

  anchor { 'nfs::begin': } ->
  class { '::nfs::install': } ->
  class { '::nfs::config': } ->
  class { '::nfs::service': } ->
  anchor { 'nfs::end': }

}
