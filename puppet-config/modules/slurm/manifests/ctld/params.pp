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

class slurm::ctld::params {
  require ::slurm

  $enable_lua      = true
  $enable_wckeys   = true

  ### Service ###
  $service_enable = true
  $service_ensure = 'running'
  $service_manage = true
  $service        = 'slurmctld'


  ### Configuration ###
  $config_manage   = true
  $submit_lua_file = "${::slurm::config_dir}/job_submit.lua"
  $submit_lua_conf = "${::slurm::config_dir}/job_submit.conf"
  $submit_lua_options = {
    'CORES_PER_NODE' => 1,
  }

  $submit_qos_exec = '/usr/sbin/slurm-gen-qos-conf'
  $submit_qos_conf = "${::slurm::config_dir}/qos.conf"

  $wckeysctl_file = '/etc/default/wckeysctl'
  $wckeysctl_options = {
    'SACCTMGR' => "/usr/bin/sacctmgr",
    'DB_NAME' => "slurm_acct_db",
    'SLURMDB_FILE' => "/etc/slurm-llnl/slurmdbd.conf",
  }


  ### Package & Configuration ###
  $packages_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $packages_manage =  true
      $packages = [
        'slurm',
        'slurm-devel',
      ]
      $submit_lua_source = 'puppet:///modules/slurm/job_submit.lua'
    }
    'Debian': {
      $packages_manage =  true
      $packages = [
        'slurmctld',
        'slurm-llnl-job-submit-plugin',
      ]
      $submit_lua_source = '/usr/lib/slurm/job_submit.lua'
    }
    default: {
      $packages_manage =  false
      $submit_lua_source = 'puppet:///modules/slurm/job_submit.lua'
    }
  }
}
