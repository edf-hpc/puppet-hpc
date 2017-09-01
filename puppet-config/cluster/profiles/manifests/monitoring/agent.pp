##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class profiles::monitoring::agent {

  $features      = hiera_array('profiles::monitoring::agent::features', [])
  $features_conf = hiera_hash('profiles::monitoring::features_conf', {})

  # if the host runs virtual machines, it must be monitored by master monitoring server
  if member(hpc_get_hosts_by_profile('virt::host'), $::hostname) {
    #zones         = hiera_hash('profiles::monitoring::agent::ext::zones', {})
    #endpoints     = hiera_hash('profiles::monitoring::agent::ext::endpoints', {})
    #$bind_network  = hiera('profiles::monitoring::agent::ext::bind_network')
    $zones         = hiera_hash('profiles::monitoring::agent::int::zones', {})
    $endpoints     = hiera_hash('profiles::monitoring::agent::int::endpoints', {})
    $bind_network  = hiera('profiles::monitoring::agent::int::bind_network')
  } else {
    $zones         = hiera_hash('profiles::monitoring::agent::int::zones', {})
    $endpoints     = hiera_hash('profiles::monitoring::agent::int::endpoints', {})
    $bind_network  = hiera('profiles::monitoring::agent::int::bind_network')
  }

  # get the network hostname of current node on the $bind_network
  $bind_host = $::mymasternet['networks'][$bind_network]['hostname']

  class { '::icinga2':
    features      => $features,
    features_conf => $features_conf,
    zones         => $zones,
    endpoints     => $endpoints,
    bind_host     => $bind_host,
  }

  include '::nscang::client'

}
