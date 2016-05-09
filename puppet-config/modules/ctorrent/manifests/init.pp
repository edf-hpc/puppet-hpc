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

class ctorrent (
  $packages         = $ctorrent::params::packages,
  $packages_ensure  = $ctorrent::params::packages_ensure,
  $default_file     = $ctorrent::params::default_file,
  $init_file        = $ctorrent::params::init_file,
  $ctorrent_options = $ctorrent::params::ctorrent_options,
  $cluster          = '',
) inherits ctorrent::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($default_file)
  validate_absolute_path($init_file)
  validate_hash($ctorrent_options)
  validate_string($cluster)

  anchor { 'ctorrent::begin': } ->
  class { '::ctorrent::install': } ->
  class { '::ctorrent::config': } ->
  class { '::ctorrent::service': } ->
  anchor { 'ctorrent::end': }

}
