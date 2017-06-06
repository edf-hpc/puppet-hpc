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

class network::params {

  $install_manage  = true
  $packages_manage = true
  $packages_ensure = 'latest'
  $config_manage   = true
  $service_manage  = true

  $routednet = {}

  $ib_mtu            = '65520'
  $ib_mode           = 'connected'

  $eth_no_offload_ifs = []

  case $::osfamily {
    'Debian': {
      $service_name = 'networking'
      ## Hostname
      $hostname_augeas_path   = '/files/etc/hostname'
      $hostname_augeas_change = "set hostname ${::hostname}"
      ## Interfaces
      $config_file      = '/etc/network/interfaces'
      $bonding_packages = ['ifenslave-2.6']
      $bridge_packages  = ['bridge-utils']
      $utils_packages   = [
        'fping',
        'ethtool',
      ]
    }
    'Redhat': {
      $service_name = 'network'
      ## Hostname
      $hostname_augeas_path   = '/files/etc/sysconfig/network'
      $hostname_augeas_change = "set HOSTNAME ${::hostname}"
      ## IRQBalance
      $irqbalance_config      = '/etc/sysconfig/irqbalance'
      ## Interfaces
      $config_file      = '/etc/sysconfig/network-scripts/ifcfg'
      $bonding_packages = ['net-tools']
      $bridge_packages  = ['bridge-utils']
      $utils_packages   = ['fping']
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }

  $service_ensure = 'running'
  $service_enable = true

  $bonding_options = {}
  $bridge_options = {}

}
