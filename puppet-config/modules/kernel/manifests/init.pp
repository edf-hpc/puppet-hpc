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

# Setup kernel parameters
#
# @param config_manage Public class manages the configuration (default: true)
# @param sysctl Hash of sysctl parameters (default: {})
# @param udev_rules Hash of udev rules (default: {})
class kernel (
  $config_manage = $::kernel::params::config_manage,
  $sysctl        = $::kernel::params::sysctl,
  $udev_rules    = $::kernel::params::udev_rules,
) inherits kernel::params {

  validate_bool($config_manage)

  if $config_manage {
    validate_hash($sysctl)
    validate_hash($udev_rules)
  }

  anchor { 'kernel::begin': } ->
  class { '::kernel::config': } ->
  anchor { 'kernel::end': }

}
