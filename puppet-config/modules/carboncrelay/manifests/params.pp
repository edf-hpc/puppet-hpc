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

class carboncrelay::params {
  $service = 'carbon-c-relay'
  $service_ensure = 'running'
  $service_enable = true

  $service_override_defaults = {
    'Service' => {
      'LimitNOFILE' => '8192'
    }
  }


  $packages = [
    'carbon-c-relay'
  ]
  $packages_ensure = 'installed'

  $config_file = '/etc/carbon-c-relay.conf'

  $cluster_type  = 'any_of'
  $cluster_order = '11'

  $rewrite_order = '21'

  $match_expression   = '*'
  $match_destinations = [ 'blackhole' ]
  $match_stop         = false
  $match_order        = '31'
}

