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
# @param content Hash with the content of the file (see `data` parameter
#          from hpclib::print_config)
define systemd::unit_override (
  $unit_name,
  $content,
) {
  validate_string($unit_name)
  validate_hash($content)

  ensure_resource(file, "/etc/systemd/system/${unit_name}.d", {ensure => directory,})

  $unit_override_file = "/etc/systemd/system/${unit_name}.d/${name}.conf"

  hpclib::print_config { $unit_override_file:
    style  => 'ini',
    data   => $content,
    notify => Exec["unit_override_systemctl_daemon_reload_${unit_name}_${name}"],
  }

  exec { "unit_override_systemctl_daemon_reload_${unit_name}_${name}":
    refreshonly => true,
    command     => '/bin/systemctl daemon-reload',
  }

}

