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
    'bck_name'       		=> 'configsafety',
    # Dar 
    'path_bck_dar_dir'         	=> 'noset',
    'path_incl_dar_file'      	=> '/etc/config-safety/path-incl-dar',
    'dest_host_dar_bck'         => 'noset',
    'dest_path_dar_back_dir'    => ' noset',
    'path_catalogue_dar_file'   => '/etc/config-safety/catalogue',
    'day_ret_dar'       	=> '5',
    # Rsync
    'path_bck_rsync_dir'    	=> 'noset',
    'rsync_opt' 		=> 'rsync -rltgoDv --del --ignore-errors --force',
    'dest_host_rsync_bck' 	=> 'noset',
    'dest_path_rsync_back_dir'  => 'noset',
    'path_excl_rsync_file'  	=> '/etc/config-safety/exclude-files-rsync',
  }

}
