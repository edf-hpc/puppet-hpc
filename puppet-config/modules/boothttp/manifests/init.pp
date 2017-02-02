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

# Setup files to serve over http for boot system
#
# @param virtual_address Hostname to insert in the kickstart/preseed for
#          the HTTP server
# @param servername Hostname for the apache virtual host
# @param serveraliases Array of FDQN hostname for the apache virtual host
# @param port TCP port of the apache virtual host
# @param packages List of packages to install
# @param packages_ensure Should packages be installed, latest or absent
# @param config_dir_http Target directory for files to serve
# @param hpc_files Hash describing hpclib::hpc_file resources to create
# @param archives Hash describing archive resources to create
# @param supported_os Array of Operating Systems to include in the
#          configuration.
# @param install_options OS install files (preseed or kickstart) options
# @param menu_source Source URL of the menu CGI
# @param menu_config Path of the menu CGI yaml configuration file
# @param menu_config_options Hash with the content of `menu_config`
class boothttp (
  $virtual_address,
  $servername,
  $serveraliases,
  $port            = $::boothttp::params::port,
  $packages        = $::boothttp::params::packages,
  $packages_ensure = $::boothttp::params::packages_ensure,
  $config_dir_http = $::boothttp::params::config_dir_http,
  $hpc_files       = $::boothttp::params::hpc_files,
  $archives        = $::boothttp::params::archives,
  $supported_os    = $::boothttp::params::supported_os,
  $install_options = $::boothttp::params::install_options,
  $menu_config     = $::boothttp::params::menu_config,
  $menu_source     = $::boothttp::params::menu_source,
  $menu_config_options,

) inherits boothttp::params {

  validate_string($virtual_address)
  validate_string($servername)
  validate_array($serveraliases)
  validate_string($port)
  validate_absolute_path($config_dir_http)
  validate_string($menu_source)
  validate_hash($hpc_files)
  validate_hash($archives)
  validate_array($supported_os)
  validate_string($menu_config)
  validate_hash($menu_config_options)


  anchor { 'boothttp::begin': } ->
  class { '::boothttp::install': } ->
  class { '::boothttp::config': } ->
  anchor { 'boothttp::end': }

}
