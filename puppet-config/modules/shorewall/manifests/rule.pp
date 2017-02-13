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

# Shorewall firewall rule
# @param source Source zone and network address for the traffic
# @param dest Destination zone and network address for the traffic
# @param proto IP protocol used (tcp, udp...)
# @param dport Destination port
# @param sport Source port
# @param origdest Original destination address (for NAT)
# @param rule The full Shorewall rule as a string, if defined all parameters
#          except order and comment are ignored
# @param order Order of the rule in the configuration file
# @param comment Comment string added to the file before the rule
define shorewall::rule (
  $action   = 'REJECT',
  $source   = '-',
  $dest     = '-',
  $proto    = '-',
  $dport    = '-',
  $sport    = '-',
  $origdest = '-',
  $rule     = undef,
  $order    = '0',
  $comment  = '',
) {

  $final_order = $order + 11

  if $rule {
    $_rule = $rule
  } else {
    $_rule = "${action} ${source} ${dest} ${proto} ${dport} ${sport} ${origdest}"
  }

  concat::fragment { "shorewall_rules_rule_${name}":
    target  => $::shorewall::rules_file,
    order   => $final_order,
    content => "#${name}: ${comment}\n${_rule}\n",
  }

}

