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

#
class multipath (
  $config             = $multipath::params::config,
  $config_opts        = $multipath::params::config_opts,
  $packages           = $multipath::params::packages,
  $packages_ensure    = $multipath::params::packages_ensure,
) inherits multipath::params {

  validate_absolute_path($config)
  validate_hash($config_opts)
  validate_array($packages)
  validate_string($packages_ensure)

  anchor { 'multipath::begin': } ->
  class { '::multipath::install': } ->
  class { '::multipath::config': } ->
  anchor { 'multipath::end': }

}
