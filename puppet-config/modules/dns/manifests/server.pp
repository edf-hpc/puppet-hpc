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
  $packages        = $::dns::params::server_packages,
  $service         = $::dns::params::server_service,
  $config_file     = $::dns::params::server_config_file,
  $local_file      = $::dns::params::server_local_file,
  $zone_file       = $::dns::params::server_zone_file,
  $zone_options    = $::dns::params::zone_options,
  $zone_defaults   = $::dns::params::zone_defaults,
  $local_domain,
  $virtual_domain,
  $domain,
  $config_options  = {},
) inherits dns::params {

  validate_array($packages)
  validate_string($service)
  validate_string($domain)
  validate_string($local_domain)
  validate_string($virtual_domain)
  validate_absolute_path($config_file)
  validate_hash($config_options)
  validate_absolute_path($local_file)
  validate_absolute_path($zone_file)
  validate_hash($zone_options)
  validate_hash($zone_defaults)

  $_config_options = merge($::dns::params::config_options_default, $config_options)

  package { $packages: }

  service { $service:
    ensure    => running,
    require   => Package[$packages],
    subscribe => [
      File[$config_file],
      File[$local_file],
      File[$zone_file],
    ],
  }

  file { $config_file:
    content => template('dns/named_conf_options.erb'),
    require => Package[$packages], 
  }

  file { $local_file:
    content => template('dns/named_conf_local.erb'),
    require => Package[$packages], 
  }

  file { $zone_file:
    content => template('dns/db_cluster.erb'),
    require => Package[$packages], 
  }

}
