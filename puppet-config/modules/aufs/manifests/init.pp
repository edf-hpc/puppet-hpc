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

# Add a remote component to system aufs (/usr/bin and /usr/share)
#
# @param service_name    Name of the service to manage (default: 'aufs')
# @param service_ensure  Target state for the service (default: 'running')
# @param service_enable  The service starts at boot time (default: true)
# @param service_options Hash with the content of the unit service file
# @param packages        Array of packages to install
# @param packages_ensure Target state for packages (default: 'installed')
# @param chroot_dir      Path of the remote chroot directory
# @param squashfs_dir    Path of the local squashfs root
# @param script_file     Path of the script file launched by the service
class aufs (
  $chroot_dir,
  $squashfs_dir,
  $service_name    = $::aufs::params::service_name,
  $service_ensure  = $::aufs::params::service_ensure,
  $service_enable  = $::aufs::params::service_enable,
  $service_options = {},
  $packages        = $::aufs::params::packages,
  $packages_ensure = $::aufs::params::packages_ensure,
  $script_file     = $::aufs::params::script_file,
  $overlay_dir     = $::aufs::params::overlay_dir,
) inherits aufs::params {

  validate_string($service_name)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_hash($service_options)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($chroot_dir)
  validate_absolute_path($script_file)
  validate_absolute_path($overlay_dir)
  validate_absolute_path($squashfs_dir)

  $_service_options = deep_merge($::aufs::params::service_options_defaults, $service_options)

  anchor { 'aufs::begin': } ->
  class { '::aufs::install': } ->
  class { '::aufs::config': } ->
  class { '::aufs::service': } ->
  anchor { 'aufs::end': }
}
