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

class configsafety::config inherits configsafety {

if $hostname == $node_cfg {

  $_template_config_files = 'configsafety/config-safety.conf.erb'
  $_template_exclude_files_rsync = 'configsafety/exclude-files-rsync.erb'
  $_template_path_incl_dar = 'configsafety/path-incl-dar.erb'
  $_template_cron_configsafety = 'configsafety/config-safety.cron.erb'

  file { $configsafety_config_files :
    content => template($_template_config_files),
    mode    => '0600',
  }
  
  file { $configsafety_exclude_files_rsync :
    content => template($_template_exclude_files_rsync),
    mode    => '0600',
  }
  
  file { $configsafety_path_incl_dar :
    content => template($_template_path_incl_dar),
    mode    => '0600',
  }
  
  file { $configsafety_cron_configsafety :
    content => template($_template_cron_configsafety),
  }

}

}
