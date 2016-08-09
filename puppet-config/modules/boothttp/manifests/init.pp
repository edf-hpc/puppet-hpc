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

# Setup files to serve over http for boot system
#
# @param virtual_address Hostname to insert in the kickstart/preseed for
#                        the HTTP server
# @param config_dir_http Target directory for files to serve
# @param menu_source     Source URL of the menu CGI
# @param supported_os    List of Operating Systems to include in the
#                        configuration.
class boothttp (

  $virtual_address,
  $config_dir_http = $::boothttp::params::config_dir_http,
  $menu_source     = $::boothttp::params::menu_source,
  $hpc_files       = $::boothttp::params::hpc_files,
  $archives        = $::boothttp::params::archives,
  $supported_os    = $::boothttp::params::supported_os,
  $install_options = $::boothttp::params::install_options,

) inherits boothttp::params {

  validate_absolute_path($config_dir_http)
  validate_string($menu_source)
  validate_hash($hpc_files)
  validate_hash($archives)
  validate_hash($supported_os)

  anchor { 'boothttp::begin': } ->
  class { '::boothttp::install': } ->
  class { '::boothttp::config': } ->
  anchor { 'boothttp::end': }

}
