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
  case $::osfamily {
    'Debian': {
      ## Hostname
      $hostname_augeas_path   = '/files/etc/hostname'
      $hostname_augeas_change = "set hostname ${::hostname}"
      ## Interfaces
      $config_file      = '/etc/network/interfaces'
      $bonding_packages = ['ifenslave-2.6']
      $bridge_packages  = ['bridge-utils']
    }
    'Redhat': {
      ## Hostname
      $hostname_augeas_path   = '/files/etc/sysconfig/network'
      $hostname_augeas_change = "set HOSTNAME ${::hostname}"
      ## IRQBalance
      $irqbalance_config      = '/etc/sysconfig/irqbalance'
      ## Interfaces
      $config_file      = '/etc/sysconfig/network-scripts/ifcfg'
      $bonding_packages = ['net-tools']
      $bridge_packages  = []
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }

  $ifup_hotplug_service_name   = 'ifup-hotplug'
  $ifup_hotplug_service_ensure = 'running'
  $ifup_hotplug_service_enable = true
  $ifup_hotplug_service_file   = "/etc/systemd/system/${ifup_hotplug_service_name}.service"
  $ifup_hotplug_service_link   = "/etc/systemd/system/multi-user.target.wants/${ifup_hotplug_service_name}"
  case $::puppet_context {
    /diskless*/ : {
      # --force is needed to force reconfiguration of eth0 interface in order
      # to run all post-up rules (ex: default gateway)
      $ifup_hotplug_service_exec = '/sbin/ifup --force --all --allow=hotplug'
    }
    default : {
      $ifup_hotplug_service_exec = '/sbin/ifup --all --allow=hotplug'
    }
  }
  $ifup_hotplug_service_params = {
    'Unit'    => {
      'Description'         => 'Mount all hotplug interfaces',
      'After'               => 'network.target auditd.service',
      'Before'              => 'network-online.target',
      # Remove dependency on basic.target
      'DefaultDependencies' => 'no',
    },
    'Service' => {
      'Type'         => 'oneshot',
      'KillMode'     => 'process',
      'ExecStartPre' => '-/bin/mkdir -m 755 -p /run/network',
      'ExecStart'    => $ifup_hotplug_service_exec,
    },
    'Install' => {
      'WantedBy'     => 'multi-user.target',
    },
  }

  $bonding_options = {}
  $bridge_options = {}

}
