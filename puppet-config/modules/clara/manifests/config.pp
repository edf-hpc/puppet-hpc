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

class clara::config inherits clara {
  hpclib::print_config{ $::clara::repos_file:
    style => 'ini',
    data  => $::clara::repos_options,
  }

  hpclib::print_config{ $::clara::config_file:
    style => 'ini',
    data  => $::clara::_config_options,
  }

  hpclib::print_config{ $::clara::virt_file:
    style => 'ini',
    data  => $::clara::_virt_options,
  }

  hpclib::print_config{ $::clara::password_file:
    style  => 'keyval',
    data   => $::clara::_password_options,
    mode   => '0600',
    owner  => 'root',
    backup => false,
  }

  file { $::clara::keyring_file :
    content => hpc_source_file($::clara::keyring_source),
    mode    => '0600',
    owner   => 'root',
  }

  create_resources(hpclib::hpc_file, $::clara::virt_tpl_hpc_files)

  create_resources(file, $::clara::live_dirs)
  create_resources(hpclib::hpc_file, $::clara::live_files)

}

