##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2017 EDF S.A.                                           #
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

# Install and setup singularity on nodes
#
# @param packages         Packages list (default: 'singularity-container')
# @param packages_ensure  Packages install mode
# @param config_file      Configuration file (default:
#          '/etc/singularity/singularity.conf')
# @param config_options   Content of the configuration file
# @param envinit_manage   The module will manager the environment init
#          script (default: true)
# @param envinit_file     Path of the environment init script (default:
#          '/etc/singularity/init')
# @param envinit_source   hpc_file source of the environment init file
#          (default: 'singularity/init')
class singularity (
  $packages         = $::singularity::params::packages,
  $packages_ensure  = $::singularity::params::packages_ensure,
  $config_file      = $::singularity::params::config_file,
  $config_options   = $::singularity::params::config_options,
  $envinit_manage   = $::singularity::params::envinit_manage,
  $envinit_file     = $::singularity::params::envinit_file,
  $envinit_source   = $::singularity::params::envinit_source,
) inherits singularity::params {
  validate_absolute_path($config_file)
  validate_array($config_options)
  validate_absolute_path($envinit_file)
  validate_string($envinit_source)
  validate_bool($envinit_manage)

  anchor { 'singularity::begin': } ->
  class { '::singularity::install': } ->
  class { '::singularity::config': } ->
  anchor { 'singularity::end': }

}
