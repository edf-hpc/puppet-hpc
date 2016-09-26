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

class network::params {

  $routednet = []

  $ib_enable         = false
  $opa_enable        = false
  $ib_udev_rule_file = '/etc/udev/rules.d/50-infiniband-permissions.rules'
  $ib_file           = '/etc/infiniband/openib.conf'
  case $::osfamily {
    'Debian': {
      ## Hostname
      $hostname_augeas_path   = '/files/etc/hostname'
      $hostname_augeas_change = "set hostname ${::hostname}"
      ## Interfaces
      $config_file      = '/etc/network/interfaces'
      $bonding_packages = ['ifenslave-2.6']
      $ib_packages      = [
        'ibverbs-utils',
        'infiniband-diags',
        'libmlx4-1',
        'libmlx5-1',
        'libibverbs1',
        'libibmad5',
        'libibumad3',
        'dapl2-utils',
        'mlnx-ofed-kernel-utils',
        'mlnx-ofed-kernel-modules',
        'knem-kernel-module',
        'mxm'
      ]
      $opa_packages     = [
        'compat-rdma-dev-3.16.0-4-amd64',
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
        'rdmacm-utils',
        'rdma'
      ]
    }
    'Redhat': {
      ## Hostname
      $hostname_augeas_path   = '/files/etc/sysconfig/network'
      $hostname_augeas_change = "set HOSTNAME ${::hostname}"
      ## Interfaces
      $config_file      = '/etc/sysconfig/network-scripts/ifcfg'
      $bonding_packages = ['net-tools']
      $ib_packages      = [
        'ar_mgr',
        'bupc',
        'cc_mgr',
        'dapl',
        'dapl-utils',
        'dump_pr',
        'fca',
        'hcoll',
        'ibacm',
        'ibdump',
        'ibutils',
        'ibutils2',
        'infiniband-diags',
        'infiniband-diags-compat',
        'kmod-iser',
        'kmod-kernel-mft-mlnx',
        'kmod-knem-mlnx',
        'kmod-mlnx-ofa_kernel',
        'kmod-srp',
        'knem-mlnx',
        'libibmad',
        'libibprof',
        'libibumad',
        'libibverbs',
        'libibverbs-utils',
        'libmlx4',
        'libmlx5',
        'librdmacm',
        'librdmacm-devel',
        'librdmacm-utils',
        'mft',
        'mlnx-ofa_kernel',
        'mlnx-ofa_kernel-devel',
        'mpfr',
        'mstflint',
        'mxm',
        'ofed-scripts',
        'perftest',
        'qperf',
        'rds-tools'
      ]
      $opa_packages     = [
      ]
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }

  $systemd_tmpfile           = '/etc/tmpfiles.d/openibd.conf'
  $systemd_tmpfile_options   = ['d    /run/network   0755 root root - -']
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
      'Description'  => 'Mount all hotplug interfaces',
      'After'        => 'network.target auditd.service',
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

  $ib_rules    = {
    umad  => 'KERNEL=="umad*", SYMLINK+="infiniband/%k", MODE="0666"',
    uverb => 'KERNEL=="uverbs*", SYMLINK+="infiniband/%k", MODE="0666"',
    issm  => 'KERNEL=="issm*", SYMLINK+="infiniband/%k", MODE="0666"',
    rdma  => 'KERNEL=="rdma*", SYMLINK+="infiniband/%k", MODE="0666"',
  }

  $mlx4load    = 'yes'
  $ib_options_defaults = {
    'onboot'                       => 'yes',
    'node_desc'                    => 'll$(hostname -s)',
    'node_desc_time_before_update' => '20',
    'set_ipoib_channels'           => 'no',
    'run_affinity_tuner'           => 'no',
    'srpha_enable'                 => 'no',
    'srp_daemon_enable'            => 'no',
    'uverbs_load'                  => 'yes',
    'ucm_load'                     => 'yes',
    'umad_load'                    => 'yes',
    'rdma_cm_load'                 => 'yes',
    'rdma_ucm_load'                => 'yes',
    'renice_ib_mad'                => 'no',
    'run_sysctl'                   => 'yes',
    'mthca_load'                   => 'no',
    'qib_load'                     => 'no',
    'ipath_load'                   => 'no',
    'mlx4_vnic_load'               => 'no',
    'mlx5_load'                    => 'yes',
    'cxgb3_load'                   => 'no',
    'cxgb4_load'                   => 'no',
    'nes_load'                     => 'no',
    'ipoib_load'                   => 'yes',
    'set_ipoib_cm'                 => 'no',
    'e_ipoib_load'                 => 'no',
    'srp_load'                     => 'no',
    'srpt_load'                    => 'no',
    'sdp_load'                     => 'no',
    'rds_load'                     => 'no',
    'qlgc_vnic_load'               => 'no',
    'srp_target_load'              => 'no',
    'rds_load'                     => 'no',
    'ehca_load'                    => 'no',
  }

  $bonding_options = {}
  $bridge_options = {}

}
