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

  file { $configsafety_config_files :
    content => template($_template_config_files),
    mode    => '0600',
  }

  hpclib::print_config{ $configsafety_exclude_files_rsync:
    style     => 'linebyline',
    data      => $config_excl_files_rsync,
    mode      => '0600',
  }

  hpclib::print_config{ $configsafety_path_incl_dar:
    style     => 'linebyline',
    data      => $config_path_incl_dar,
    mode      => '0600',
  }

  hpclib::print_config{ $configsafety_cron_configsafety:
    style     => 'linebyline',
    data      => $config_cron_configsafety,
    mode      => '0600',
  }

}

}
