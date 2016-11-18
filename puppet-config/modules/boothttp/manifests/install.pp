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

class boothttp::install inherits boothttp {

  $menu_dir                        = "${boothttp::config_dir_http}/cgi-bin"
  $menu_file                       = "${menu_dir}/bootmenu.py"
  $disk_dir                        = "${boothttp::config_dir_http}/disk"

  ensure_resource('file',$boothttp::config_dir_http,{'ensure' => 'directory'})
  ensure_resource('file',$menu_dir,{'ensure' => 'directory'})

  $_menu_config_dir = dirname($::boothttp::menu_config)
  ensure_resource('file',
                  $_menu_config_dir,
                  {'ensure' => 'directory'})

  file { $menu_file:
    content => hpc_source_file($::boothttp::menu_source),
    mode    => '0755',
  }

  create_resources(hpclib::hpc_file, $::boothttp::hpc_files)
  create_resources(archive, $::boothttp::archives)

}
