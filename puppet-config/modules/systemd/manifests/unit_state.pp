##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

# Ensure the systemd unit has expected FileState
#
# @param name Name of the unit (ex: 'apache2')
# @param unit_type Type of the systemd unit (ex: 'mount', default: 'service')
# @param service_name Target state (ex: 'disabled', default: 'enabled')
define systemd::unit_state (
  $unit_type = 'service',
  $state = 'enabled',
) {

  $_unit_name = "${name}.${unit_type}"
  validate_re($state, ['^enabled$','^disabled','^masked'])

  $_resource_name = "systemd_unit_${name}_state"
  $_systemctl = '/bin/systemctl'

  # first unmask if target state is enabled or disabled and unit is masked
  case $state {
    'enabled', 'disabled': {
      exec { "${_resource_name}_unmask":
        command => "${_systemctl} unmask ${_unit_name}",
        onlyif  => "${_systemctl} is-enabled ${$_unit_name} | grep -q masked",
      }
    }
    default: {
      debug('no need to unmask since target state is masked')
    }
  }

  # set target state if necessary
  case $state {
    'enabled': {
      exec { $_resource_name:
        command => "${_systemctl} enable ${_unit_name}",
        unless  => "${_systemctl} is-enabled ${$_unit_name} | grep -q enabled",
      }
    }
    'disabled': {
      exec { $_resource_name:
        command => "${_systemctl} disable ${_unit_name}",
        unless  => "${_systemctl} is-enabled ${$_unit_name} | grep -q disabled",
      }
    }
    'masked': {
      exec { $_resource_name:
        command => "${_systemctl} mask ${_unit_name}",
        unless  => "${_systemctl} is-enabled ${$_unit_name} | grep -q masked"
      }
    }
    default: {
      warning("unknown unit file state: ${$state}")
    }
  }

}

