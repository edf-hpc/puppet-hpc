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
  $cgroup_rel_dir          = "${::slurm::config_dir}/cgroup"
  $cgroup_file             = "${::slurm::config_dir}/cgroup.conf"
  $cgroup_relscript_file   = "${cgroup_rel_dir}/release_common"
  $cgroup_relscript_source = '/usr/share/doc/slurmd/examples/cgroup.release_common'
  $cgroup_relcpuset_file   = "${cgroup_rel_dir}/release_cpuset"
  $cgroup_relfreezer_file  = "${cgroup_rel_dir}/release_freezer"
  $cgroup_relmem_file      = "${cgroup_rel_dir}/release_memory"
  $cgroup_options_defaults = {
    'CgroupAutomount' => {
      value   => 'yes',
      comment => 'Auto Mount',
    },
    'CgroupReleaseAgentDir' => {
      value   => $cgroup_rel_dir,
      comment => 'Path of scripts to release cgroups',
    },
    'ConstrainCores' => {
      value   => 'no',
      comment => 'Core affinity',
    },
    'ConstrainRAMspace' => {
      value   => 'no',
      comment => 'Memory Usage',
    },
  }


  ### Custom scripts ###
  $tmp_create_file = "${::slurm::scripts_dir}/TaskProlog.d/tmp_create.sh"
  $tmp_create_src  = 'puppet:///modules/slurmd/tmp_create.sh'
  $tmp_remove_file = "${::slurm::scripts_dir}/TaskEpilog.d/tmp_remove.sh"
  $tmp_remove_src  = 'puppet:///modules/slurmd/tmp_remove.sh'


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
