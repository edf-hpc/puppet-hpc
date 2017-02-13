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

# Shorewall network interface definition
#
# @param zone Name of the zone associated with this interface
# @param options Array of options to add to the interface (default: [])
define shorewall::interface (
  $zone,
  $options = [],
) {

  $options_string = join($options, ',')

  concat::fragment { "shorewall_interfaces_interface_${name}":
    target  => $::shorewall::interfaces_file,
    order   => '11',
    content => "${zone} ${name} ${options_string}\n"
  }

}

