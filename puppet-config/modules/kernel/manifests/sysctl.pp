##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2018 EDF S.A.                                      #
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

    if $::osfamily == 'RedHat' {
      notice('Module dependencies not supported with RedHat OS Family')
    } else {
      validate_string($module)
      validate_absolute_path($prefix)

      kernel::udev { "udev_sysctl_${name}":
        rules => [ "ACTION==\"add\", SUBSYSTEM==\"module\", KERNEL==\"${module}\", RUN+=\"/lib/systemd/systemd-sysctl --prefix=${prefix}\"" ],
      }
    }
  }

  # Ensure the directory of sysctl configuration file exist. This is notably
  # needed on RHEL6 where the /etc/sysctl.d directory does not exist by default.
  ensure_resource(file,
                  dirname($_file),
                  { ensure => 'directory' })

  hpclib::print_config { $_file:
    style => 'keyval',
    data  => $params,
  }

  exec { "sysctl_${name}":
    command     => $::kernel::params::sysctl_command,
    refreshonly => true,
    subscribe   => File[$_file],
    path        => ['/bin','/sbin'],
  }

}
