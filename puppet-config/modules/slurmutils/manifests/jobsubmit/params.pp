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

class slurmutils::jobsubmit::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['slurm-llnl-job-submit-plugin']
  $packages_ensure = 'latest'

  $config_manage   = true
  $conf_dir        = '/etc/slurm-llnl'
  $script_file     = "${conf_dir}/job_submit.lua"
  $script_source   = '/usr/lib/slurm/job_submit.lua'
  $conf_file       = "${conf_dir}/job_submit.conf"

  $conf_options_defaults = {
    'CORES_PER_NODE' => 1,
  }

  $gen_qos_exec = '/usr/sbin/slurm-gen-qos-conf'
  $gen_qos_conf = "${conf_dir}/qos.conf"

  $wckeysctl_file = '/etc/default/wckeysctl'
  $default_wckeysctl_options = {
    'SACCTMGR' => "/usr/bin/sacctmgr",
    'DB_NAME' => "slurm_acct_db",
    'SLURMDB_FILE' => "/etc/slurm-llnl/slurmdbd.conf",
  }
  $wckeys_data_files = {}

}
