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
define carboncrelay::match (
  $expression   = $::carboncrelay::params::match_expression,
  $destinations = $::carboncrelay::params::match_destination,
  $stop         = $::carboncrelay::params::match_stop,
  $order        = $::carboncrelay::params::match_order,
) {
  validate_string($expression)
  validate_array($destinations)
  validate_string($order)
  validate_bool($stop)
  
  concat::fragment {"'carboncrelay_config_match_${name}":
    target    => $::carboncrelay::config_file,
    order     => $order,
    content   => template('carboncrelay/config.match.erb'),
  }

}
