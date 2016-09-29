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

class ceph::fsmount (
  $packages        = $::ceph::fsmount::params::packages,
  $packages_ensure = $::ceph::fsmount::params::packages_ensure,
  $packages_manage = $::ceph::fsmount::params::packages_manage,
  $config_manage   = $::ceph::fsmount::params::config_manage,
  $key_file        = $::ceph::fsmount::params::key_file,
  $key_owner       = $::ceph::fsmount::params::key_owner,
  $key_group       = $::ceph::fsmount::params::key_group,
  $key_mode        = $::ceph::fsmount::params::key_mode,
  $mount_manage    = $::ceph::fsmount::params::mount_manage,
  $mount_device    = $::ceph::fsmount::params::mount_device,
  $mount_point     = $::ceph::fsmount::params::mount_point,
  $mount_user      = $::ceph::fsmount::params::mount_user,
  $mon_servers     = $::ceph::fsmount::params::mon_servers,
  $key,
) inherits ceph::fsmount::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_bool($packages_manage)
  validate_bool($config_manage)
  validate_absolute_path($key_file)
  validate_string($key_owner)
  validate_string($key_group)
  validate_integer($key_mode)
  validate_bool($mount_manage)
  validate_string($mount_device)
  validate_string($mount_point)
  validate_string($mount_user)
  validate_array($mon_servers)
  validate_string($key)

  if $config_manage {
    $_key_dir = dirname($key_file)
  }

  if $mount_manage {
    $_device = sprintf("%s:%s",
                      join($mon_servers, ','),
                      $mount_device)
    $_options = sprintf("name=%s,secretfile=%s",
                        $mount_user,
                        $key_file)
  }

  anchor { 'ceph::fsmount::begin': } ->
  class { '::ceph::fsmount::install': } ->
  class { '::ceph::fsmount::config': } ->
  class { '::ceph::fsmount::mount': } ->
  anchor { 'ceph::fsmount::end': }

}
