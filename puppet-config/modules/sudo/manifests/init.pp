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

# Install and configure sudo
#
# @param packages Package list
# @param packages_ensure Package install mode
# @param config_file Main configuration file path (`/etc/sudoers`)
# @param config_options Content of the configuration file (Array of lines)
class sudo (
  $packages               = $sudo::params::packages,
  $packages_ensure        = $sudo::params::packages_ensure,
  $config_file            = $sudo::params::config_file,
  $config_options         = $sudo::params::config_options,
) inherits sudo::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_array($config_options)

  anchor { 'sudo::begin': } ->
  class { '::sudo::install': } ->
  class { '::sudo::config': } ->
  anchor { 'sudo::end': }

}
