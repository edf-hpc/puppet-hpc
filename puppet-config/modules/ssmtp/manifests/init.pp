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

class ssmtp (
  $packages         = $::ssmtp::params::packages,
  $packages_ensure  = $::ssmtp::params::packages_ensure,
  $config_file      = $::ssmtp::params::config_file,
  $config_options   = {},
) inherits ssmtp::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_hash($config_options)

  $_config_options = merge($::ssmtp::params::config_options_default, $config_options)

  anchor { 'ssmtp::begin': } ->
  class { '::ssmtp::install': } ->
  class { '::ssmtp::config': } ->
  anchor { 'ssmtp::end': }
}
