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

# Install and configure the FusionInventory agent on nodes
#
# @param packages 	  Packages list (default: ['fusioninventory-agent'])
# @param packages_ensure  Target state for the packages (default: 'present')
# @param config_file      Absolute path to the agent configuration file
#                         (default: '/etc/fusioninventory/agent.cfg')
# @param config_options   Hash of options to include in the configuration file
# @param default_file     Absolute path to the default configuration file of 
#                         the FusionInventory agent                       
# @param default_options  Hash of options for the default configuration file
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
