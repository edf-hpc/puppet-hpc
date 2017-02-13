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

# Shorewall policy (default rule)
#
# @param source Source zone and network for this policy
# @param dest Destination zone and network for this policy
# @param policy Action to apply (default: 'REJECT')
# @param log_level Log to apply when policy is triggered (default: none)
# @param order Order of the policy in the config file (default: 0)
define shorewall::policy (
  $source,
  $dest,
  $policy    = 'REJECT',
  $log_level = '-',
  $order     = '0',
) {

  $final_order = $order + 11

  concat::fragment { "shorewall_policies_policy_${name}":
    target  => $::shorewall::policy_file,
    order   => $final_order,
    content => "#${name}\n${source} ${dest} ${policy} ${log_level}\n"
  }

}

