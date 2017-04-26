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

# Install and configure the system to collect data from FusionInventory
# agents and to push it to the GLPI server
#
# @param hpc_files	  Hash listing the scripts to install (Default: {})
# @param servername Hostname for the apache virtual host
# @param serveraliases Array of FDQN hostname for the apache virtual host
# @param port TCP port of the apache virtual host
# @param config_dir_http Target directory for files to serve

class glpicollector (
  $virtual_address,
  $servername,
  $serveraliases,
  $port            = $::glpicollector::params::port,
  $hpc_files       = $::glpicollector::params::hpc_files,
  $config_dir_http = $::glpicollector::params::config_dir_http,
) inherits glpicollector::params {

  validate_string($virtual_address)
  validate_string($servername)
  validate_array($serveraliases)
  validate_string($port)
  validate_absolute_path($config_dir_http)
  validate_hash($hpc_files)

  anchor { 'glpicollector::begin': } ->
  class { '::glpicollector::install': } ->
  class { '::glpicollector::config': } ->
  anchor { 'glpicollector::end': }

}
