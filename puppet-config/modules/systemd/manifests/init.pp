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

# This module can be used to modify the parameters of the system manager in
# /etc/systemd/system.conf. Since we do not want to maintain the parameters
# list with their default values in the module, it just modifies selected
# lines. The drawback is that a configuration change does not restore previous
# settings.

class systemd (
  $config_manage          = $::systemd::params::config_manage,
  $system_manager_options = $::systemd::params::system_manager_options,
) inherits systemd::params {

  validate_bool($config_manage)
  if $config_manage {
    validate_hash($system_manager_options)

    # The function hpc_hmap() is used here to transform the following hash
    # format:
    #
    #  { $param1 => $value1,
    #    $param2 => $value2, }
    #
    # into:
    #
    #  { $param1 => { value => $value1 },
    #    $param2 => { value => $value2 }, }

    $_system_manager_options = hpc_hmap($system_manager_options,
                                        'value')
  }

  anchor { 'systemd::begin': } ->
  class { '::systemd::config': } ->
  anchor { 'systemd::end': }

}
