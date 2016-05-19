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

class shorewall::config inherits shorewall {
  augeas { 'shorewall_default_startup':
    changes => [
      "set /files/${::shorewall::default_file}/startup 1",
    ],
    notify  => Class['::shorewall::service'],
  }


  if $::shorewall::ip_forwarding {
    $ip_forwarding_str = 'Yes'
  } else {
    $ip_forwarding_str = 'Keep'
  }

  augeas { 'shorewall_conf_ip_forwarding':
    lens    => 'Shellvars.lns',
    incl    => $::shorewall::config_file,
    changes => [
      "set IP_FORWARDING ${ip_forwarding_str}",
    ],
  }

  concat { $::shorewall::zones_file:
    ensure => present,
  }
  concat::fragment { 'shorewall_zones_header':
    target  => $::shorewall::zones_file,
    order   => '01',
    content => template('shorewall/zones.header.erb')
  }
  Concat::Fragment <| target == $::shorewall::zones_file |>

  concat { $::shorewall::interfaces_file:
    ensure => present,
  }
  concat::fragment { 'shorewall_interfaces_header':
    target  => $::shorewall::interfaces_file,
    order   => '01',
    content => template('shorewall/interfaces.header.erb')
  }
  Concat::Fragment <| target == $::shorewall::interfaces_file |>

  concat { $::shorewall::policy_file:
    ensure => present,
  }
  concat::fragment { 'shorewall_policies_header':
    target  => $::shorewall::policy_file,
    order   => '01',
    content => template('shorewall/policy.header.erb')
  }
  Concat::Fragment <| target == $::shorewall::policy_file |>

  concat { $::shorewall::masq_file:
    ensure => present,
  }
  concat::fragment { 'shorewall_masq_header':
    target  => $::shorewall::masq_file,
    order   => '01',
    content => template('shorewall/masq.header.erb')
  }
  Concat::Fragment <| target == $::shorewall::masq_file |>

  concat { $::shorewall::rules_file:
    ensure => present,
  }
  concat::fragment { 'shorewall_rules_header':
    target  => $::shorewall::rules_file,
    order   => '01',
    content => template('shorewall/rules.header.erb')
  }
  Concat::Fragment <| target == $::shorewall::rules_file |>
}

