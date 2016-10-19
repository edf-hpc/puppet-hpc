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

class dns::server (
  $manage_packages = $::dns::server::params::manage_packages,
  $packages        = $::dns::server::params::packages,
  $packages_ensure = $::dns::server::params::packages_ensure,
  $manage_services = $::dns::server::params::manage_services,
  $services        = $::dns::server::params::services,
  $services_ensure = $::dns::server::params::services_ensure,
  $config_dir      = $::dns::server::params::config_dir,
  $config_file     = $::dns::server::params::config_file,
  $local_file      = $::dns::server::params::local_file,
  $zone_defaults   = $::dns::server::params::zone_defaults,
  $virtual_domain  = $::dns::server::params::virtual_domain,
  $config_options  = {},
  $zones           = {},
) inherits dns::server::params {

  validate_bool($manage_packages)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_bool($manage_services)
  validate_array($services)
  validate_string($services_ensure)
  validate_absolute_path($config_dir)
  validate_absolute_path($config_file)
  validate_absolute_path($local_file)
  validate_hash($zone_defaults)
  validate_hash($config_options)
  validate_hash($zones)

  if $manage_config {
    $_config_options = merge($::dns::server::params::config_options_default, $config_options)
  }

  anchor { 'dns::server::begin': } ->
  class { '::dns::server::install': } ->
  class { '::dns::server::config': } ->
  class { '::dns::server::service': } ->
  anchor { 'dns::server::end': }

}
