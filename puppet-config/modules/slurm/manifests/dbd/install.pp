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

class slurm::dbd::install inherits slurm::dbd {

  if $::slurm::dbd::packages_manage {

    package { $::slurm::dbd::packages:
      ensure => $::slurm::dbd::packages_ensure,
    }

  }

  # To create the archive directory, we extract its path from the slurmdbd
  # configuration hash. This hash only exists if dbd::config_manage is true,
  # hence this test.
  if $::slurm::dbd::config_manage {

    $_archive_dir = $::slurm::dbd::_config_options['ArchiveDir']
    $_slurm_user = $::slurm::dbd::_config_options['SlurmUser']

    # If the ArchiveDir is not defined in slurmdbd configuration, do nothing.

    if $_archive_dir != undef {
      file { $_archive_dir:
        ensure => directory,
        owner  => $_slurm_user,
        group  => $_slurm_user,
        mode   => 0755,
      }
    }
  }
}
