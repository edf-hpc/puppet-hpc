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

class slurmutils::backupdb::install inherits slurmutils::backupdb {

  if $::slurmutils::backupdb::install_manage {

    if $::slurmutils::backupdb::packages_manage {
      package { $::slurmutils::backupdb::packages:
        ensure => $::slurmutils::backupdb::package_ensure,
      }
    }

    $_backup_dir = $::slurmutils::backupdb::_conf_options['BKDIR']
    $_slurm_user = $::slurm::dbd::_config_options['SlurmUser']

    ensure_resource('file',
                    $_backup_dir,
                    {
                      ensure => directory,
                      owner  => $_slurm_user,
                      group  => $_slurm_user,
                      mode   => 0755,
                    })
  }

}
