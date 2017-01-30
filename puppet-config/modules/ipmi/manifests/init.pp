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


# Load ipmi modules during boot
#
# Use the distribution method to automatically load a module on boot
#
# @param config_file Path of the file where the modules are added (
#           default: depends on the distribution)
# @param config_options Array listing the modules (default: depends on
#           the distribution)
# @param config_file_mode Default mode for `config_file`
# @param config_file_template Which template to use for `config_file`
class ipmi (
  $config_file          = $ipmi::params::config_file,
  $config_options       = $ipmi::params::config_options,
  $config_file_template = $ipmi::params::config_file_template,
  $config_file_mode     = $ipmi::params::config_file_mode,
) inherits ipmi::params {

  validate_absolute_path($config_file)
  validate_array($config_options)

  anchor { 'ipmi::begin': } ->
  class { '::ipmi::config': } ->
  anchor { 'ipmi::end': }

}
