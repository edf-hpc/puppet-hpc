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

# Bittorrent opentracker server
#
# @param packages Array of package names
# @param packages_ensure Target state of the packages (default: 'latest')
# @param default_file Path of the file with the default parameter
# @param config_dir Path of the directory where the configuration is
# @param config_file Basename of the configuration file
# @param opentracker_default_options Hash with the content of the ``default_file``
# @param systemd_service_file Path of the systemd service unit file
# @param systemd_service_file_options Hash with the content of
#          ``systemd_service_file``
# @param admin_node Name of the node that can get stats from the tracker
# @param tracker_nodes Array with the name of all the tracker nodes (this one
#          included)
class opentracker (
  $packages                     = $opentracker::params::packages,
  $packages_ensure              = $opentracker::params::packages_ensure,
  $default_file                 = $opentracker::params::default_file,
  $config_dir                   = $opentracker::params::config_dir,
  $config_file                  = $opentracker::params::config_file,
  $opentracker_default_options  = $opentracker::params::opentracker_default_options,
  $systemd_service_file         = $opentracker::params::systemd_service_file,
  $systemd_service_file_options = $opentracker::params::systemd_service_file_options,
  $admin_node,
  $tracker_nodes,
) inherits opentracker::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($default_file)
  validate_absolute_path($config_dir)
  validate_string($config_file)
  validate_hash($opentracker_default_options)
  validate_string($admin_node)
  validate_array($tracker_nodes)
  validate_absolute_path($systemd_service_file)
  validate_hash($systemd_service_file_options)

  anchor { 'opentracker::begin': } ->
  class { '::opentracker::install': } ->
  class { '::opentracker::config': } ->
  class { '::opentracker::service': } ->
  anchor { 'opentracker::end': }

}
