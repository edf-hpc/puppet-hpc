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

# Setup a firewall
#
# ## Hiera
# * `profiles::firewall::rules` (`hiera_hash`)
class profiles::firewall::base {
  include ::shorewall

  ::shorewall::zone { 'fw':
    type => 'firewall',
  }
  ::shorewall::zone { 'wan':
    type => 'ipv4',
  }
  ::shorewall::zone { 'clstr':
    type => 'ipv4',
  }

  ::shorewall::policy { 'to_wan':
    source => 'all',
    dest   => 'wan',
    policy => 'REJECT',
    order  => 1,
  }
  ::shorewall::policy { 'other':
    source => 'all',
    dest   => 'all',
    policy => 'ACCEPT',
    order  => 11,
  }

  # Interfaces are created by hpclib functions, that
  # interpret the content of hiera to create the relevant entries
  # for the current host.
  # see modules/hpclib/puppet/parser/functions/shorewall.rb
  $interfaces = hpc_shorewall_interfaces()
  create_resources('::shorewall::interface', $interfaces)

  $rules = hiera_hash('profiles::firewall::rules')
  create_resources('::shorewall::rule', $rules)

}
