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

# Deploys kernel sysctl parameters file

define kernel::sysctl (
  $params,
  $file   = undef,
  $module = undef,
  $prefix = undef,
) {

  if $file == undef {
    $_file = "${::kernel::params::sysctl_dir}/${name}.conf"
  } else {
    $_file = $file
  }

  validate_absolute_path($_file)
  validate_hash($params)

  # if module is defined, create udev rule
  if $module != undef {

    validate_string($module)
    validate_absolute_path($prefix)

    kernel::udev { "udev_sysctl_${name}":
      rules => [ "ACTION==\"add\", SUBSYSTEM==\"module\", KERNEL==\"${module}\", RUN+=\"/lib/systemd/systemd-sysctl --prefix=${prefix}\"" ],
    }
  }

  hpclib::print_config { $_file:
    style => 'keyval',
    data  => $params,
  }

  exec { "sysctl_${name}":
    command     => "${$::kernel::params::sysctl_exec} -p ${_file}",
    refreshonly => true,
    subscribe   => File[$_file],
    path        => ['/bin','/sbin'],
  }

}
