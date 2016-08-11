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

class hpc_conman::server::params {
  $vip_name = undef
  $roles = [
    'admin',
    'batch',
    'bm',
    'cg',
    'critical',
    'cn',
    'front',
    'misc',
  ]
  $device_type = 'ipmi'
  $port_default = {
    'ipmi'   =>  undef,
    'telnet' =>  21,
  }
  $prefix_default = {
    'ipmi'   =>  'bmc',
    'telnet' =>  'con',
  }
}

