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

class dns::client (
  $header      = $dns::params::cl_header,
  $domain      = $dns::params::cl_domain,
  $search      = $dns::params::cl_search,
  $options     = $dns::params::cl_options,
  $nameservers = $dns::params::cl_nameservers,
  $cfg         = $dns::params::cl_cfg,
) inherits dns::params {

  file { $cfg :
    content => template('dns/resolv_conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

