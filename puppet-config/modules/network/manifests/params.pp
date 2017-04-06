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

  $routednet = []

  $opa_enable        = false
  $ib_mtu            = '65520'
  $ib_mode           = 'connected'
  case $::osfamily {
    'Debian': {
      ## Hostname
      $hostname_augeas_path   = '/files/etc/hostname'
      $hostname_augeas_change = "set hostname ${::hostname}"
      ## IRQBalance
      $irqbalance_config = '/etc/default/irqbalance'
      ## Interfaces
      $config_file      = '/etc/network/interfaces'
      $bonding_packages = ['ifenslave-2.6']
      $bridge_packages  = ['bridge-utils']
      $opa_packages     = [
#        'compat-rdma-dev-3.16.0-4-amd64',
        'compat-rdma-modules-3.16.0-4-amd64',
        'hfi1-diagtools-sw',
        'hfi1-firmware',
        'hfi1-utils',
        'ibacm',
        'ibverbs-utils',
        'infiniband-diags',
        'libhfi1',
        #'libhfi1-psm',  # dependency of hfi1-diagtools-sw
        #'libibmad5',  # dependency of infiniband-diags (among others)
        #'libibnetdisc5', # dependency of infiniband-diags (among others)
        #'libibumad3', # dependency of infiniband-diags (among others)
        #'libibverbs1', # dependency of rdmacm-utils
        #'librdmacm1', # dependency of rdmacm-utils
        'opa-address-resolution',
        #'opa-basic-tools', # dependency of opa-scripts
        'opa-scripts',
        # 'qperf',
        'irqbalance',
        'rdmacm-utils',
        'rdma'
      ]
      $opa_kernel_modules = [
        'ib_ipoib',
      ]
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
      $opa_packages     = []
      $opa_kernel_modules = []
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }

  $irqbalance_service = 'irqbalance'
  $irqbalance_ensure  = running
  $irqbalance_enable  = true
  $irqbalance_options = {
    'enabled' => '1',
    'oneshot' => '0',
    'options' => '--hintpolicy=exact'
  }

  $ifup_hotplug_service      = 'ifup-hotplug'
  $ifup_hotplug_service_file = "/etc/systemd/system/${ifup_hotplug_service}.service"
  $ifup_hotplug_service_link = "/etc/systemd/system/multi-user.target.wants/${ifup_hotplug_service}"
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

  $ifup_hotplug_services = {
    'ifup-hotplug' => {
      ensure  => 'running',
      enable  => true,
      require => Hpclib::Systemd_service[$ifup_hotplug_service_file],
    },
  }

  $ifup_hotplug_files = {
    "${ifup_hotplug_service_link}" => {
      ensure  => link,
      target  => $ifup_hotplug_service_file,
      require => Hpclib::Systemd_service[$ifup_hotplug_service_file],
    },
  }

  $bonding_options = {}
  $bridge_options = {}

}
