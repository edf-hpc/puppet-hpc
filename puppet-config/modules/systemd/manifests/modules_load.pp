##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

# Create a modules-load file and load it
#
# The file will be created with the name of the resource
#
# @param data Content of the file as an array of lines
# @param config_dir Configuration dir for the file
# @param service_name Name of the service
define systemd::modules_load (
  $data,
  $config_dir   = '/etc/modules-load.d',
  $service_name = 'systemd-modules-load',
) {

  validate_array($data)
  validate_absolute_path($config_dir)
  validate_string($service_name)

  $config_file = "${config_dir}/${name}.conf"

  hpclib::print_config { $config_file:
    style  => 'linebyline',
    data   => $data,
    notify => Exec["systemd_modules_load_restart_${name}"],
  }

  exec { "systemd_modules_load_restart_${name}":
    refreshonly => true,
    command     => "/bin/systemctl restart ${service_name}.service",
  }

}

