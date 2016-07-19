##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2015 EDF S.A.                                      #
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

# Add sysctl settings and load them
#
# This will create a file in `/etc/sysctl.d` and load this file with
# `sysctl -p`. File are automatically read during boot.
#
# @param config       Hash with keyval entries for sysctl settings
# @param sysctl_file  Name of the file to create relative to
#                     `/etc/sysctl.d`
define hpclib::sysctl(
  $config,
  $sysctl_file,
) {

  $root_dir       = '/etc/sysctl.d'
  $sysctl_command = 'sysctl'

  hpclib::print_config { "${root_dir}/${sysctl_file}":
    style => 'keyval',
    data  => $config,
  }

  exec { "${sysctl_command}_${sysctl_file}":
    command     => "${sysctl_command} -p ${root_dir}/${sysctl_file}",
    refreshonly => true,
    subscribe   => File["${root_dir}/${sysctl_file}"],
    path        => ['/bin','/sbin'],
  }
}
