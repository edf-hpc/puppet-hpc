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

# Configure failover for the NFS server
#
# @param vip_name When ha_failover is true, the failover will be tied to
#          the hpc_ha::vip with this name
# @param lvm_vg Name of the volume group to lock with tags before mounting
#          the FS when ha_failover is true.
# @param fence_method Fencing method to use on the partner node when the
#          ha_failover is true, should be one of: DEBUG, CLARA_VIRT,
#          CLARA_IPMI (default: DEBUG)
# @param mount_points Array of mount points path to mount and check before
#          exporting when ha_failover is true (default: [])
# @param multipath_name Name of the multipath device to check, empty string
#          to disable the check (default: '')
# @param v4recovery_dir Path of the v4recovery directory on a shared storage,
#          this can be inside a mount point (default: undef)
class hpc_nfs::ha_server (
  $vip_name,
  $lvm_vg,
  $fence_method   = $::hpc_nfs::ha_server::params::fence_method,
  $mount_points   = $::hpc_nfs::ha_server::params::mount_points,
  $multipath_name = $::hpc_nfs::ha_server::params::multipath_name,
  $v4recovery_dir = $::hpc_nfs::ha_server::params::v4recovery_dir,
) inherits hpc_nfs::ha_server::params {
  validate_string($lvm_vg)
  validate_re($fence_method, ['^CLARA_VIRT', '^CLARA_IPMI', '^DEBUG'])
  validate_array($mount_points)
  validate_string($vip_name)
  validate_string($multipath_name)
  if $v4recovery_dir {
    validate_absolute_path($v4recovery_dir)
  }

  anchor { 'hpc_nfs::ha_server::begin': } ->
  class { '::hpc_nfs::ha_server::config': } ->
  anchor { 'hpc_nfs::ha_server::end': }

}
