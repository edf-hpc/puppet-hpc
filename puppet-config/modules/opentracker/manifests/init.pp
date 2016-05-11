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
