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

class shorewall::params {
  $service = 'shorewall'
  $service_ensure = running
  $service_enable = true
  $packages = [ 'shorewall' ]
  $packages_ensure = 'installed'
  $ip_forwarding = false

  $config_dir      = '/etc/shorewall'
  $config_file     = "${config_dir}/shorewall.conf"
  $interfaces_file = "${config_dir}/interfaces"
  $zones_file      = "${config_dir}/zones"
  $masq_file       = "${config_dir}/masq"
  $policy_file     = "${config_dir}/policy"
  $rules_file      = "${config_dir}/rules"

  $default_file = '/etc/default/shorewall'

}

