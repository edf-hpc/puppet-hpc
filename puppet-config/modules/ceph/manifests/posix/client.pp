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

class ceph::posix::client (
  $packages        = $::ceph::posix::client::params::packages,
  $packages_ensure = $::ceph::posix::client::params::packages_ensure,
  $packages_manage = $::ceph::posix::client::params::packages_manage,
  $keys_dir        = $::ceph::posix::client::params::keys_dir,
  $keys_owner      = $::ceph::posix::client::params::keys_owner,
  $keys_group      = $::ceph::posix::client::params::keys_group,
  $keys_mode       = $::ceph::posix::client::params::keys_mode,
  $keys            = $::ceph::posix::client::params::keys,
  $mounts,
) inherits ceph::posix::client::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_bool($packages_manage)
  validate_absolute_path($keys_dir)
  validate_string($keys_owner)
  validate_string($keys_group)
  validate_integer($keys_mode)
  validate_hash($keys)
  validate_hash($mounts)

  anchor { 'ceph::posix::client::begin': } ->
  class { '::ceph::posix::client::install': } ->
  class { '::ceph::posix::client::keys': } ->
  class { '::ceph::posix::client::mounts': } ->
  anchor { 'ceph::posix::client::end': }

}
