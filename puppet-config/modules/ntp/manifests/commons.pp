##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2015 EDF S.A.                                      #
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

class ntp::commons (
  $preferred_servers = $ntp::params::preferred_servers,
  $servers           = $ntp::params::servers,
  $restrict          = $ntp::params::restrict,
  $config            = $ntp::params::config,
  $service_name      = $ntp::params::service_name,
  $package_list      = $ntp::params::package_list,
  $default_config    = $ntp::params::default_config,
  $service_opts      = $ntp::params::service_opts,
) inherits ntp::params {

  tools::print_config { $default_config :
    style   => 'keyval',
    params  => $service_opts,
    require => Package[$package_list]
  }

  $ntp_files = {
    "${config}"     => {
      content    => template('ntp/ntp_conf.erb'),
      require    => Package[$package_list],
    },
  }

  create_resources(file,$ntp_files)

  $ntp_services = {
    "${service_name}" => {
      ensure     => 'running',
      require    => Package[$package_list],
      subscribe  => [File[$config],File[$default_config]],
    },
  }

  create_resources(service,$ntp_services)

  package { $package_list :
    ensure     => 'installed',
  }
}
