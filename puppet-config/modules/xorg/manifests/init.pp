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


# Installs Xorg
#
# This class installs the xorg package and define a Instanced service unit
# file. Instances are define as resources with xorg::instance.
# 
class xorg (
  $service         = $::xorg::params::service,
  $service_file    = $::xorg::params::service_file,
  $service_options = {},
  $packages        = $::xorg::params::packages,
  $packages_ensure = $::xorg::params::packages_ensure,
) inherits xorg::params {
  validate_string($service)
  validate_absolute_path($service_file)
  validate_hash($service_options)
  validate_array($packages)
  validate_string($packages_ensure)

  $_service_options = deep_merge($::xorg::params::service_options_defaults, $service_options)

  anchor { 'xorg::begin': } ->
  class { '::xorg::install': } ->
  class { '::xorg::config': } ->
  anchor { 'xorg::end': }

}
