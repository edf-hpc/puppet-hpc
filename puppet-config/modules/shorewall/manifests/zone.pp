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

# Shorewall zone definition
#
# @param name Name of the zone
# @param type Zone type (default: 'firewall')
# @param options Array of options for the zone
# @param comment Comment string added before the zone in the configuration
#          file
define shorewall::zone (
  $type    = 'firewall',
  $options = [],
  $comment = '',
) {

  $options_str = join($options, ',')

  concat::fragment { "shorewall_zones_zone_${name}":
    target  => $::shorewall::zones_file,
    order   => '11',
    content => "#${name}: ${comment}\n${name} ${type} ${options}\n"
  }

}

