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

class clustershell::config inherits clustershell {
  hpclib::print_config{ $::clustershell::groups_file:
    style     => 'ini',
    data      => $::clustershell::_groups_options,
    separator => ': ',
  }

  # clustershell and nodeset fails if an empty group
  # file is created
  if $::clustershell::groups == {} {
    file { $::clustershell::groups_yaml_file:
      ensure => absent
    }
  } else {
    hpclib::print_config{ $::clustershell::groups_yaml_file:
      style => 'yaml',
      data  => $::clustershell::groups,
    }
  }
}

