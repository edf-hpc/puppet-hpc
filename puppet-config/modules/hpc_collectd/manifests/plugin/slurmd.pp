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

#== Class: hpc_collectd::plugin::slurmd
#
# Class to manage slurmd plugin for collectd 
# === Parameters
# [*ensure*]
#   ensure param for collectd::plugin type
# 
# [*cgroupmountpoint*]
#   path where the cgroup hierarchy is mounted
#   example: "/cgroup"
#
# [*ignoreabsentcpuset*] 
#   When set to false, the plugin returns an error 
#   if the cpuset Cgroup hierarchy maintained by Slurm is not found.
#   This puppet module reverse the default to: true
class hpc_collectd::plugin::slurmd (
  $ensure             = present,
  $cgroupmountpoint   = "/cgroup",
  $ignoreabsentcpuset = true,
) {
  validate_absolute_path($cgroupmountpoint)
  validate_bool($ignoreabsentcpuset)

  collectd::plugin {'slurmd':
    ensure  => $ensure,
    content => template('hpc_collectd/plugin/slurmd.conf.erb'),
  }
}
