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

class environment::config inherits environment {

  file { $::environment::motd_path :
    ensure  => file,
    content => template('environment/motd.erb'),
  }

  file { $::environment::ssh_autogenkeys_script:
    path    => "${::environment::profiles_directory}/${::environment::ssh_autogenkeys_script}",
    content => template($::environment::ssh_autogenkeys_script_tpl),
  }

  debug("Log Commands Enable: ${::environment::log_commands_enable} (${::environment::log_commands_facility})")
  file { "${::environment::profiles_directory}/000_config.sh":
    content => template('environment/000_config.sh.erb'),
  }

  create_resources(file, $::environment::files, $::environment::files_defaults)
}
