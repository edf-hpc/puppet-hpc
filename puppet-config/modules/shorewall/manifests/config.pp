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
      "set /files/etc/default/shorewall/startup 1",
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
    incl    => '/etc/shorewall/shorewall.conf',
    changes => [
      "set IP_FORWARDING ${ip_forwarding_str}",
    ],
  }

  concat { '/etc/shorewall/zones':
    ensure => present,
  }
  concat::fragment { 'shorewall_zones_header':
    target  => '/etc/shorewall/zones',
    order   => '01',
    content => template('shorewall/zones.header.erb')
  }
  Concat::Fragment <| target == '/etc/shorewall/zones' |>

  concat { '/etc/shorewall/interfaces':
    ensure => present,
  }
  concat::fragment { 'shorewall_interfaces_header':
    target  => '/etc/shorewall/interfaces',
    order   => '01',
    content => template('shorewall/interfaces.header.erb')
  }
  Concat::Fragment <| target == '/etc/shorewall/interfaces' |>

  concat { '/etc/shorewall/policy':
    ensure => present,
  }
  concat::fragment { 'shorewall_policies_header':
    target  => '/etc/shorewall/policy',
    order   => '01',
    content => template('shorewall/policy.header.erb')
  }
  Concat::Fragment <| target == '/etc/shorewall/policy' |>

  concat { '/etc/shorewall/masq':
    ensure => present,
  }
  concat::fragment { 'shorewall_masq_header':
    target  => '/etc/shorewall/masq',
    order   => '01',
    content => template('shorewall/masq.header.erb')
  }
  Concat::Fragment <| target == '/etc/shorewall/masq' |>

  concat { '/etc/shorewall/rules':
    ensure => present,
  }
  concat::fragment { 'shorewall_rules_header':
    target  => '/etc/shorewall/rules',
    order   => '01',
    content => template('shorewall/rules.header.erb')
  }
  Concat::Fragment <| target == '/etc/shorewall/rules' |>
}

