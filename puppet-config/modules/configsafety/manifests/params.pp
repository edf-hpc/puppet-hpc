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

class configsafety::params {

  $packages_ensure 			= 'latest'
  $packages        			= ['config-safety']
  $configsafety_config_files            = '/etc/config-safety/config-safety.conf'
  $configsafety_exclude_files_rsync     = '/etc/config-safety/exclude-files-rsync'
  $configsafety_path_incl_dar           = '/etc/config-safety/path-incl-dar'
  $configsafety_cron_configsafety       = '/etc/cron.d/config-safety'

  $config_options_defaults = {
    'BCKNAME' => '"configsafety"',
    'LOG' => '"/var/log/config-safety/backup-configsafety-status.log"',
    # Dar
    'PATHADMIN' => '"noset"',
    'PATH_INCL' => '"/etc/config-safety/path-incl-dar"',
    'DESTBCK' => '"noset"',
    'PATHBCK' => '"noset"',
    'CATALOGUE' => '"/etc/config-safety/catalogue"',
    'NBRET' => '"5"',
    # Rsync
    'RPATHADMIN' => '"noset"',
    'RSYNCOPT' => '"rsync -rltgoDv --del --ignore-errors --force"',
    'RSSH' => '"noset"',
    'RPATHBCK' => '"noset"',
    'EXCLUDE' => '"/etc/config-safety/exclude-files-rsync"',
  }

}
