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

# Install the warewulf-nhc node checker tool
#
# @param packages packages list
# @param packages_ensure packages install mode
# @param config_file Main configuration file path (`nhc.conf`)
# @param config_options Content of `nhc.conf` in a hash
# @param default_file Service configuration file path
#  (`/etc/default/nhc` on Debian)
# @param default_options Content of `/etc/default/nhc` in a hash
class warewulf_nhc (
  $packages        = $warewulf_nhc::params::packages,
  $packages_ensure = $warewulf_nhc::params::packages_ensure,
  $config_file     = $warewulf_nhc::params::config_file,
  $default_file    = $warewulf_nhc::params::default_file,
  $default_options = $warewulf_nhc::params::default_options,
  $config_options  = {},
) inherits warewulf_nhc::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_hash($config_options)
  validate_absolute_path($default_file)
  validate_hash($default_options)

  anchor { 'warewulf_nhc::begin': } ->
  class { '::warewulf_nhc::install': } ->
  class { '::warewulf_nhc::config': } ->
  anchor { 'warewulf_nhc::end': }

}
