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

class slurm::exec::params {
  require ::slurm

  ### Service ###
  $service_enable = true
  $service_ensure = 'running'
  $service_manage = true

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      if $::operatingsystemmajrelease < 7 {
        $service = 'slurm'
      }
      else {
        $service = 'slurmd'
      }
    }
    default: {
      $service = 'slurmd'
    }
  }

  ### Configuration ###
  $config_manage   = true

  ### Cgroups ###
  $enable_cgroup           = true
  $cgroup_file             = "${::slurm::config_dir}/cgroup.conf"
  $cgroup_options_defaults = {
    'CgroupAutomount'       => 'no',
    'ConstrainCores'        => 'yes',
    'ConstrainRAMspace'     => 'no',
    'TaskAffinity'          => 'yes',
  }

  ### Package ###
  $package_ensure = 'present'
  case $::osfamily {
    'RedHat': {
      $packages_manage = true
      $packages        = [
        'slurm',
        'slurm-plugins',
      ]
    }
    'Debian': {
      $packages_manage = true
      $packages        = [
        'slurmd',
        'slurm-wlm-basic-plugins',
      ]
    }
    default: {
      $packages_manage =  false
    }
  }
}
