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

class dns::params {

# Module variables
  $sr_pkgs        = ['bind9']
  $sr_serv        = 'bind9'
  $sr_cfg_options = '/etc/bind/named.conf.options'
  $sr_cfg_local   = '/etc/bind/named.conf.local'
  $sr_cfg_zone    = '/etc/bind/db.cluster'
  $cl_header      = ''
  $cl_domain      = ''
  $cl_search      = ''
  $cl_options     = []
  $cl_nameservers = []
  $cl_cfg         = '/etc/resolv.conf'

# Default values
  $profile_opts = {
    'directory'          => '/var/cache/bind',
    'auth-nxdomain'      => 'no',
    'listen-on-v6'       => 'none',
    'dnssec-validation'  => 'auto',
  }
  $profile_local = {
    'type'               => 'master',
    'file'               => $sr_cfg_zone,
  }
  $cluster_zone_defaults = {
    'TTL'                => '604800',
    'Serial'             =>  '2',
    'Refresh'            =>  '604800',
    'Retry'              =>  '86400',
    'Expire'             =>  '2419200',
    'Negative cache TTL' =>  '604800',
  }
}
