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

class slurmutils::setupwckeys::config inherits slurmutils::setupwckeys {

  if $::slurmutils::setupwckeys::config_manage {

      hpclib::print_config { $::slurmutils::setupwckeys::wckeysctl_file:
        style     => 'keyval',
        separator => '=',
        data      => $::slurmutils::setupwckeys::_wckeysctl_options,
      }

      create_resources(hpclib::hpc_file,
                       $::slurmutils::setupwckeys::wckeys_data_files)

  }

}
