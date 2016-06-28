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

# NTP local server
#
# ## Hiera
# * `profiles::ntp::server::site_preferred_servers` (`hiera_array`)
# * `profiles::ntp::server::site_servers` (`hiera_array`)
# * `profiles::ntp::srv_def_cfg`
# * `profiles::ntp::srv_opts`
class profiles::ntp::server {

  ## Hiera lookups
  $preferred_servers = hiera_array('profiles::ntp::server::site_preferred_servers')
  $servers           = hiera_array('profiles::ntp::server::site_servers')

  # Pass server name as a class parameter
  class { '::ntp':
    preferred_servers           => $preferred_servers,
    servers                     => $servers,
  }

  # Modify default options of ntp service
  $srv_name = $ntp::params::service_name
  $srv_def_cfg = hiera('profiles::ntp::srv_def_cfg')
  $srv_opts = hiera('profiles::ntp::srv_opts')
  hpclib::print_config { $srv_def_cfg :
    style   => 'keyval',
    data    => $srv_opts,
    notify  => Service[$srv_name],
  }

}
