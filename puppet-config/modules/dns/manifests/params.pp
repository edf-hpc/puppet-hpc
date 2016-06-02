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

class dns::params {

  # Module variables
  $server_packages    = ['bind9']
  $server_service     = 'bind9'
  $server_config_file = '/etc/bind/named.conf.options'
  $server_local_file  = '/etc/bind/named.conf.local'
  $server_zone_file   = '/etc/bind/db.cluster'
  $client_header      = ''
  $client_domain      = ''
  $client_search      = ''
  $client_options     = []
  $client_nameservers = []
  $client_config_file = '/etc/resolv.conf'

  # Default values
  $config_options_default = {
    'directory'         => '/var/cache/bind',
    'auth-nxdomain'     => 'no',
    'listen-on-v6'      => 'none',
    'dnssec-validation' => 'auto',
  }

  $zone_options = {
    'type' => 'master',
    'file' => $server_zone_file,
  }

  $zone_defaults = {
    'TTL'                => '604800',
    'Serial'             => '2',
    'Refresh'            => '604800',
    'Retry'              => '86400',
    'Expire'             => '2419200',
    'Negative cache TTL' => '604800',
  }
}
