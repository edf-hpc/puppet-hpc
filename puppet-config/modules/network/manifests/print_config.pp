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

define network::print_config ($target = 'eth0') {

  $service_name = $::network::service_name
  case $::osfamily {
    'Debian': {
      $filename     = $::network::config_file
      $tplname      = 'network/interfaces.erb'
    }
    'Redhat': {
      $filename     = "${::network::config_file}-${target}"
      $tplname      = 'network/ifcfg.erb'
    }
    default: {
      fail ("Unsupported OS Family '${::osfamily}', should be: 'Redhat', 'Debian'")
    }
  }

  file { $filename :
    content => template($tplname),
    notify  => Service[$service_name]
  }

}
