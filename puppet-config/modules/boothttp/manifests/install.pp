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
  $menu_file                       = "${menu_dir}/bootmenu.rb"
  $disk_dir                        = "${boothttp::config_dir_http}/disk"
  ensure_resource('file',[$boothttp::config_dir_http,$menu_dir],{'ensure' => 'directory'})

  $boot_files          = {
    "${menu_file}"        => {
      source                   => $boothttp::menu_source,
      mode                     => '755',
      validate_cmd             => "test -d `dirname ${menu_file}`",
    },
    "${disk_dir}"        => {
      source                   => $boothttp::disk_source,
      ensure                   => 'directory',
      recurse                  => 'remote',
      validate_cmd             => "test -d `dirname ${disk_dir}`",
    },
  }

  create_resources(file,$boot_files)

}

