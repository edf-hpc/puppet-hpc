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

# Setup a firewall
#
# Interfaces configuration are built from the
# `hpclib::hpc_shorewall_interfaces` function. This function get
# association between the network topology of the cluster and the
# interfaces configured on this host in the `master_network`.
#
# ## Base configuration
#
# A base configuration close to the following is expected to be
# configured in your hiera
#
# ```
# profiles::firewall::zones:
#   'fw':
#     'type': 'firewall'
#   'wan':
#     'type': 'ipv4'
#   'clstr':
#     'type': 'ipv4'
# profiles::firewall::policies:
#   'to_wan':
#     'source': 'all'
#     'dest':   'wan'
#     'policy': 'REJECT'
#     'order':  '1'
#   'other':
#     'source': 'all'
#     'dest':   'all'
#     'policy': 'ACCEPT'
#     'order':  '11'
# ```
#
# ## Hiera
# * `profiles::firewall::rules` (`hiera_hash`)    Hash of rules to apply
#                                                 on this host
# * `profiles::firewall::zones` (`hiera_hash`)    hash of zones to apply
#                                                 on this host
# * `profiles::firewall::policies` (`hiera_hash`) Hash of policies to
#                                                 apply on this host
class profiles::firewall::base {
  include ::shorewall

  $zones = hiera_hash('profiles::firewall::zones')
  create_resources('::shorewall::zone', $zones)

  $policies = hiera_hash('profiles::firewall::policies')
  create_resources('::shorewall::policy', $policies)

  # Interfaces are created by hpclib functions, that
  # interpret the content of hiera to create the relevant entries
  # for the current host.
  # see modules/hpclib/puppet/parser/functions/shorewall.rb
  $interfaces = hpc_shorewall_interfaces()
  create_resources('::shorewall::interface', $interfaces)

  $rules = hiera_hash('profiles::firewall::rules')
  create_resources('::shorewall::rule', $rules)

}
