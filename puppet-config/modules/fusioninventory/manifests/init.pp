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

class fusioninventory (
  $packages        = $fusioninventory::params::packages,
  $packages_ensure = $fusioninventory::params::packages_ensure,
  $config_file     = $fusioninventory::params::config_file,
  $config_options  = $fusioninventory::params::config_options,
  $default_file    = $fusioninventory::params::default_file,
  $default_options = $fusioninventory::params::default_options,
) inherits fusioninventory::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_hash($config_options)
  validate_absolute_path($default_file)
  validate_hash($default_options)

  anchor { 'fusioninventory::begin': } ->
  class { '::fusioninventory::install': } ->
  class { '::fusioninventory::config': } ->
  anchor { 'fusioninventory::end': }

}
