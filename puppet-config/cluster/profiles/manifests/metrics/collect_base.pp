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

# Local network configuration
#
# ## Hiera
# * `cluster_prefix`
# * `profiles::metrics::relay_host`
class profiles::metrics::collect_base {
  include ::collectd

  # The default relay is <prefix><role> of the role having the 
  # metrics::relay role
  $cluster_prefix = hiera('cluster_prefix')
  $relay_host_default = "${cluster_prefix}${::my_metrics_relay}"
  $relay_host = hiera( 'profiles::metrics::relay_host', $relay_host_default)

  ::collectd::plugin::write_graphite::carbon { 'relay':
    graphitehost      => $relay_host,
    graphiteport      => 2003,
    graphiteprefix    => '',
    protocol          => 'tcp',
    alwaysappendds    => false,
    storerates        => true,
    separateinstances => false,
    logsenderrors     => true
  }

  # Metrics we want pretty much everywhere
  include ::collectd::plugin::cpu
  include ::collectd::plugin::load
  include ::collectd::plugin::uptime
  include ::collectd::plugin::memory

  ::collectd::plugin { 'match_regex':
    ensure => present,
  }

  ::collectd::plugin::aggregation::aggregator { 'cpu':
    plugin           => 'cpu',
    type             => 'cpu',
    groupby          => ["Host", "TypeInstance",],
    calculateaverage => true,
    calculatesum     => true,
  }
    
  class { '::collectd::plugin::chain':
    chainname     => "PostCache",
    defaulttarget => "write",
    rules         => [
      {
        'match' => {
          'type'    => 'regex',
          'matches' => {
            'Plugin'         => '^cpu$',
            'PluginInstance' => '^[0-9]+$',
          }
        },
        'targets' => [
          {
            'type'      => 'write',
            'attributes' => {
              'Plugin' => 'aggregation',
            },
          },
          {
            'type' => "stop",
          },
        ],
      },
    ],
  }
}
