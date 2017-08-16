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

# NTP local server
#
# ## Hiera
# * `profiles::ntp::server::site_preferred_servers` (`hiera_array`)
# * `profiles::ntp::server::site_servers` (`hiera_array`)
# * `profiles::ntp::server::restrict` (`hiera_array`) Array of restrict lines
#     to configure the ntp clients authorized to connect
# * `profiles::ntp::server::interfaces` (`hiera_array`) Array of interfaces
#     on which the ntp server will listen, must include the source interface
#     for upstream requests
# * `profiles::ntp::srv_def_cfg`
# * `profiles::ntp::srv_opts`
class profiles::ntp::server {

  ## Hiera lookups
  $preferred_servers = hiera_array('profiles::ntp::server::site_preferred_servers')
  $servers           = hiera_array('profiles::ntp::server::site_servers')
  $restrict          = hiera_array('profiles::ntp::server::restrict')
  $interfaces        = hiera_array('profiles::ntp::server::interfaces')

  debug("Preferred servers: ${preferred_servers}, other servers: ${servers}")

  # Pass server name as a class parameter
  class { '::ntp':
    preferred_servers => $preferred_servers,
    servers           => $servers,
    restrict          => $restrict,
    interfaces        => $interfaces,
  }

  # Modify default options of ntp service
  $srv_name = $ntp::params::service_name

  case $::osfamily {
    'RedHat': {
      $default_file = '/etc/sysconfig/ntpd'
    }
    'Debian': {
      $default_file = '/etc/default/ntp'
    }
    default: {
      $default_file = unset
    }
  }

  $srv_def_cfg = hiera('profiles::ntp::srv_def_cfg', $default_file)
  $srv_opts = hiera('profiles::ntp::srv_opts')
  hpclib::print_config { $srv_def_cfg :
    style  => 'keyval',
    data   => $srv_opts,
    notify => Service[$srv_name],
  }

}
