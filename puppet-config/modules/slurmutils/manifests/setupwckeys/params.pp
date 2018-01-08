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

class slurmutils::setupwckeys::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['slurm-llnl-setup-wckeys']
  $packages_ensure = 'latest'

  $config_manage   = true
  $conf_dir        = '/etc/slurm-llnl'

  $wckeysctl_file = '/etc/default/wckeysctl'
  $default_wckeysctl_options = {
    'SACCTMGR' => "/usr/bin/sacctmgr",
    'DB_NAME' => "slurm_acct_db",
    'SLURMDB_FILE' => "/etc/slurm-llnl/slurmdbd.conf",
  }
  $wckeys_data_files = {}

}
