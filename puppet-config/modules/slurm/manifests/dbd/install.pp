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

class slurm::dbd::install inherits slurm::dbd {

  if $::slurm::dbd::packages_manage {

    package { $::slurm::dbd::packages:
      ensure => $::slurm::dbd::packages_ensure,
    }

  }

  # To create the archive and DB backup directories, we extract theirs paths
  # respectively from the slurmdbd configuration and the db backup options
  # hashes. These hashes are defined only if dbd::config_manage is true,
  # hence this test.

  if $::slurm::dbd::config_manage {

    $_slurm_user = $::slurm::dbd::_config_options['SlurmUser']

    # A common set of resources properties are defined to make sure both
    # archive and backup directories are created with the same properties and
    # avoid a resource conflict with ensure_resource() in case they share the
    # same path.

    $_dir_props = {
      ensure => directory,
      owner  => $_slurm_user,
      group  => $_slurm_user,
      mode   => 0755,
    }


    # If the ArchiveDir is not defined in slurmdbd configuration, do nothing.
    $_archive_dir = $::slurm::dbd::_config_options['ArchiveDir']
    if $_archive_dir != undef {
      ensure_resource('file', $_archive_dir, $_dir_props)
    }

    # The _db_backup_option hash is defined only if db_backup_enable is true,
    # hence this additional test.
    if $::slurm::dbd::db_backup_enable {
      $_backup_dir = $::slurm::dbd::_db_backup_options['BKDIR']
      ensure_resource('file', $_backup_dir, $_dir_props)
    }
  }
}
