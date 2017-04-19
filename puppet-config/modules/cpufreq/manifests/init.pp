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

# Configure Cpufrequtil service
#
# @param packages Package list
# @param packages_ensure Package install mode (default:
#                        'present)
# @param default_file Default configuration file path (default: 
#                     '/etc/default/cpufrequtils')
# @param default_options Hash with the content of `default_file` 
#                        (merged with defaults)
# @param service_ensure   Should the service run or be stopped (default: running)
# @param service_enable Boolean: is the service starting at boot (default: true)

class cpufreq (
  $packages        = $cpufreq::params::packages,
  $packages_ensure = $cpufreq::params::packages_ensure,
  $default_file    = $cpufreq::params::default_file,
  $service_ensure  = $cpufreq::params::service_ensure,
  $service_enable  = $cpufreq::params::service_enable,  
  $default_options = {},
) inherits cpufreq::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($default_file)
  validate_hash($default_options)

  $_default_options=deep_merge($cpufreq::params::default_options_defaults, $defaults_options)

  anchor { 'cpufreq::begin': } ->
  class { '::cpufreq::install': } ->
  class { '::cpufreq::config': } ->
  class { '::cpufreq::service': } ->
  anchor { 'cpufreq::end': }

}
