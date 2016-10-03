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

# Job scheduler execution node
#
# A generic configuration is defined in
# ``puppet-hpc/hieradata/common.yaml", in your own hiera files you could
# just redefine, the following values:
#
# ## Common
# ```
# slurm_primary_server:         "%{hiera('cluster_prefix')}%{::my_jobsched_server}1"
# slurm_secondary_server:       "%{hiera('cluster_prefix')}%{::my_jobsched_server}2"
# ```
# A generic configuration for warewulf-nhc is defined in
# ``puppet-hpc/hieradata/common.yaml", in your own hiera files you could
# change or add some checks
#
# ## Hiera
#
# * profiles::jobsched::slurm_config_options (`hiera_hash`) Content of the slurm
#         configuration file.
# * profiles::warewulf_nhc::config_options (`hiera_hash`) Content of the
#         NHC configuration file.
class profiles::jobsched::exec {
  # Install slurm and munge
  $slurm_config_options = hiera_hash('profiles::jobsched::slurm_config_options')
  class { '::slurm':
    config_options => $slurm_config_options,
  }
  include ::munge
  $cgroup_options = hiera_hash('profiles::jobsched::exec::cgroup_options')
  class { '::slurm::exec':
    cgroup_options => $cgroup_options,
  }
  Class['::slurm'] -> Class['::slurm::exec']
  Class['::munge::service'] -> Class['::slurm::exec::service']

  # Restrict access to execution nodes
  include ::pam
  include ::pam::slurm

  # Install and configure NodeHealthChecker
  $nhc_config_options = hiera_hash('profiles::warewulf_nhc::config_options')
  class { '::warewulf_nhc':
    config_options => $nhc_config_options,
  }

}
