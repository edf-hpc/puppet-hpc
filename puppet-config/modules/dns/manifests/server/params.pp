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

class dns::server::params {

  # Module variables
  $manage_packages = true
  $packages        = [ 'bind9' ]
  $packages_ensure = 'present'
  $manage_services = true
  $services        = [ 'bind9' ]
  $services_ensure = 'running'
  $manage_config   = true
  $config_dir      = '/etc/bind'
  $config_file     = "${config_dir}/named.conf.options"
  $local_file      = "${config_dir}/named.conf.local"
  $virtual_domain  = undef # disable by default

  # Default values
  $config_options_default = {
    'directory'          => '/var/cache/bind',
    'auth-nxdomain'      => 'no',
    'listen-on-v6'       => 'none',
    'dnssec-validation'  => 'auto',
    # By default if recursion is enabled, bind will activate default
    # empty reverse dns zones. We don't want those. It should be true
    # only if the upstream dns server is a public internet one.
    'empty-zones-enable' => 'no',
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
