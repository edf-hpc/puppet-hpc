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

class environment::config inherits environment {

  file { $motd_path :
    ensure  => file,
    content => template('environment/motd.erb'),
  }

  file { "${ssh_autogenkeys_script}" :
    path    => "${profiles_directory}/${ssh_autogenkeys_script}",
    content => template($ssh_autogenkeys_script_tpl),
  }

 create_resources(file,$files,$files_defaults)
}
