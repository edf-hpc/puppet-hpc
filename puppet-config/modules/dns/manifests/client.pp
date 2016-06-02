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

class dns::client (
  $header      = $::dns::params::client_header,
  $domain      = $::dns::params::client_domain,
  $search      = $::dns::params::client_search,
  $options     = $::dns::params::client_options,
  $nameservers = $::dns::params::client_nameservers,
  $config_file = $::dns::params::client_config_file,
) inherits dns::params {

  validate_string($header)
  validate_string($domain)
  validate_string($search)
  validate_array($nameservers)
  validate_absolute_path($config_file)

  file { $config_file :
    content => template('dns/resolv_conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

