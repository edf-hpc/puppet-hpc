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

# Write an OS install file
#
# @param name name of the resource and OS name of the install to write
define boothttp::printconfig () {

  $_os = $name
  $config_file = "${::boothttp::install::disk_dir}/${_os}/install_config"

  # Calibre9 uses a hash passed as parameter directly written as a preseed
  # RH still uses a direct template
  if $_os == 'calibre9' {
    # Test if install_options has key and fail if not. Otherwise, Puppet returns
    # an empty string when accessing a missing key in a hash. Then, it leads to
    # weird error in hpclib::print_config.
    if !has_key($::boothttp::install_options, $_os) {
      fail("install_options hash does not have key for os ${_os}")
    }
    $install_options = $::boothttp::install_options[$_os]
    hpclib::print_config{ $config_file:
      style     => 'keyval',
      data      => $install_options,
      separator => ' ',
    }
  } else {
    $template_file   = "boothttp/install_config.${_os}.erb"
    $virtual_address = $boothttp::virtual_address

    file { $config_file:
      ensure  => 'present',
      content => template($template_file)
    }
  }

}
