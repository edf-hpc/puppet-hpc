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

class hpc_ha (
  $default_notify_script = $::hpc_ha::params::default_notify_script,
  $sysctl_file           = $::hpc_ha::params::sysctl_file,
  $sysctl_options        = $::hpc_ha::params::sysctl_options,
) inherits hpc_ha::params {
  include keepalived

  validate_string($sysctl_file)
  validate_hash($sysctl_options)

  anchor { 'hpc_ha::begin': } ->
  class { '::hpc_ha::install': } ->
  class { '::hpc_ha::config': } ->
  class { '::hpc_ha::service': } ->
  anchor { 'hpc_ha::end': }

}
