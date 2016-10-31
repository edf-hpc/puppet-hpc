##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class profiles::monitoring::server {

  $features      = hiera_array('profiles::monitoring::server::features', [])
  $features_conf = hiera_hash('profiles::monitoring::features_conf', {})
  $zones         = hiera_hash('profiles::monitoring::server::zones', {})
  $endpoints     = hiera_hash('profiles::monitoring::server::endpoints', {})

  class { '::icinga2':
    features      => $features,
    features_conf => $features_conf,
    zones         => $zones,
    endpoints     => $endpoints,
  }
}
