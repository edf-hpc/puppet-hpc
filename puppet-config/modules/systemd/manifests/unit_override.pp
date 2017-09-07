##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016-2017 EDF S.A.                                      #
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

# Setup a unit override
#
# Put a file a in /etc/systemd/system/<unit_name>.d to extend or override
# a unit definition.
#
# @param name Name of the override (ex: 'limits')
# @param unit_name Full unit name, including type (ex: 'apache2.service')
# @param content Hash or array with the content of the file (see `data` parameter
#          from hpclib::print_config)
# @param style Format of the content parameter (see `style` parameter from
#          hpclib::print_config) (default: ini)
# @param restart_now Restart the unit after setting the override (default: false)
define systemd::unit_override (
  $unit_name,
  $content,
  $style       = 'ini',
  $restart_now = false,
) {
  validate_string($unit_name)

  case $style {
    ini : {
      validate_hash($content)
    }
    keyval : {
      validate_hash($content)
    }
    linebyline : {
      validate_array($content)
    }
    yaml : {
      validate_hash($content)
    }
    default : {
      fail("The ${style} style is not supported.")
    }
  }

  ensure_resource(file, "/etc/systemd/system/${unit_name}.d", {ensure => directory,})

  $unit_override_file = "/etc/systemd/system/${unit_name}.d/${name}.conf"

  hpclib::print_config { $unit_override_file:
    style  => $style,
    data   => $content,
    notify => Exec["unit_override_systemctl_daemon_reload_${unit_name}_${name}"],
  }

  exec { "unit_override_systemctl_daemon_reload_${unit_name}_${name}":
    refreshonly => true,
    command     => '/bin/systemctl daemon-reload',
  }

  if $restart_now {
    exec { "unit_override_systemctl_restart_${unit_name}_${name}":
      refreshonly => true,
      command     => "/bin/systemctl restart ${unit_name}",
      subscribe   => Exec["unit_override_systemctl_daemon_reload_${unit_name}_${name}"],
    }
  }

}

