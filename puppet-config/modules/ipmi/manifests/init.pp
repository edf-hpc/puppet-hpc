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
