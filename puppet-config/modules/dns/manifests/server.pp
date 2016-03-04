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

class dns::server (
  $pkgs                  = $dns::params::sr_pkgs,
  $serv                  = $dns::params::sr_serv,
  $domain                = $dns::params::sr_domain,
  $cfg_options           = $dns::params::sr_cfg_options,
  $cfg_local             = $dns::params::sr_cfg_local,
  $cfg_zone              = $dns::params::sr_cfg_zone,
  $site_opts             = $dns::params::site_opts,
  $profile_opts          = $dns::params::profile_opts,
  $profile_local         = $dns::params::profile_local,
  $cluster_zone_defaults = $dns::params::cluster_zone_defaults,
) inherits dns::params {

  $main_config = merge($profile_opts,$site_opts)

  package { $pkgs :}

  service { $serv :
    ensure    => running,
    require   => Package[$pkgs],
    subscribe => File[$cfg_options,$cfg_local,$cfg_zone],
  }

  file { $cfg_options :
    content => template('dns/named_conf_options.erb'),
    require => Package[$pkgs],
  }

  file { $cfg_local :
    content => template('dns/named_conf_local.erb'),
    require => Package[$pkgs],
  }

  file { $cfg_zone :
    content => template('dns/db_cluster.erb'),
    require => Package[$pkgs],
  }

}
