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
class boothttp (

  $virtual_address,
  $config_dir_http                 = $boothttp::params::config_dir_http,
  $menu_source                     = $boothttp::params::menu_source,
  $disk_source                     = $boothttp::params::disk_source,
  $supported_os                    = $boothttp::params::supported_os,

) inherits boothttp::params {

  validate_absolute_path($config_dir_http)
  validate_absolute_path($menu_source)
  validate_absolute_path($disk_source)
  validate_hash($supported_os)

  anchor { 'boothttp::begin': } ->
  class { '::boothttp::install': } ->
  class { '::boothttp::config': } ->
  anchor { 'boothttp::end': }

}
