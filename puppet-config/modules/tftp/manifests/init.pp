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

class tftp (
  $package_ensure    = $::tftp::params::package_ensure,
  $packages          = $::tftp::params::packages,
  $service_ensure    = $::tftp::params::service_ensure,
  $service           = $::tftp::params::service,
  $config_file       = $::tftp::params::config_file,
  $config_options    = $::tftp::params::config_options,

) inherits tftp::params {

  validate_string($package_ensure)
  validate_array($packages)
  validate_string($service)
  validate_string($service_ensure)
  validate_absolute_path($config_file)
  validate_hash($config_options)

  anchor { 'tftp::begin': } ->
  class { '::tftp::install': } ->
  class { '::tftp::config': } ->
  class { '::tftp::service': } ->
  anchor { 'tftp::end': }

}
