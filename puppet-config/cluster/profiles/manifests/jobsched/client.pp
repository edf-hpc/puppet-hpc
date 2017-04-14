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

# Job scheduler client tools
#
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
#
# ## Hiera
#
# * profiles::jobsched::gen_scripts::enabled (`hiera`) Use generic scripts?
#         (default: true)
# * profiles::jobsched::slurm_config_options (`hiera_hash`) Content of the slurm
#         configuration file.
class profiles::jobsched::client {

  # Use generic scripts?
  $use_genscripts = hiera('profiles::jobsched::gen_scripts::enabled', true)

  # If use_genscripts is true, include genscript utility and merge its conf
  # excerpt into slurm configuration hash extracted from hiera.
  if $use_genscripts {
    include ::slurmutils::genscripts
    $slurm_config_options = deep_merge(
      hiera_hash('profiles::jobsched::slurm_config_options'),
      $::slurmutils::genscripts::params::genscripts_options)
  } else {
    $slurm_config_options = hiera_hash('profiles::jobsched::slurm_config_options')
  }

  # Install slurm and munge
  $slurm_config_options = hiera_hash('profiles::jobsched::slurm_config_options')
  class { '::slurm':
    config_options => $slurm_config_options
  }
  include ::munge
}
