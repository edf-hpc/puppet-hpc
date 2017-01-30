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

# Metrics collection for job scheduler execution node
#
# Collect metrics specific to slurmd.
#
# ## Hiera
# * `profiles::metrics::collect_packages` (`hiera_array`), default: `libslurm29`
class profiles::metrics::collect_jobsched_exec {
  $packages = hiera_array(profiles::metrics::collect_packages, [
    "libslurm29"
  ])
  package { $packages:
    ensure => installed,
  }

  include ::hpc_collectd::plugin::slurmd
}
