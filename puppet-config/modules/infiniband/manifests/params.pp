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

class infiniband::params {

  $install_manage  = true
  $packages_manage = true
  $packages_ensure = 'latest'
  $config_manage   = true
  $service_manage  = true

  case $::osfamily {
    'Debian': {
      $ofed_version = 'mlnx'
      $ofed_packages = {
        'mlnx' => [
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
        ],
      }
    }
    'Redhat': {
      $ofed_version = 'mlnx'
      $ofed_packages = {
        'mlnx' => [
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
        ],
        'native' => [
          'libibcm',
          'libibverbs',
          'libibverbs-utils',
          'librdmacm',
          'librdmacm-utils',
          'rdma',
          'dapl',
          'ibacm',
          'ibsim',
          'ibutils',
          'libcxgb3',
          'libibmad',
          'libibumad',
          'libipathverbs',
          'libmlx4',
          'libmthca',
          'libnes',
          'rds-tools',
          'compat-dapl',
          'glusterfs-rdma',
          'infiniband-diags',
          'libibcommon',
          'mstflint',
          'perftest',
          'qperf',
        ],
      }
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }

  $ofed_ib_file = {
    'mlnx'   => '/etc/infiniband/openib.conf',
    'native' => '/etc/rdma/rdma.conf',
  }

  $ofed_service_name = {
    'mlnx'   => 'openibd',
    'native' => 'rdma',
  }

  $net_topology        = hiera_hash('net_topology')
  if $net_topology['lowlatency'] {
    $ib_hostname = join(["${net_topology['lowlatency']['prefixes']}", '$(hostname -s)'], '')
  } else {
    notice("'lowlatency' network is not defined in net_topology. ib_hostname will be empty")
    $ib_hostname = ''
  }

  $ib_options_defaults = {
    'onboot'                       => 'yes',
    'node_desc'                    => $ib_hostname,
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

  $mlx4load    = 'yes'

  $systemd_tmpfile           = '/etc/tmpfiles.d/openibd.conf'
  $systemd_tmpfile_options   = ['d    /run/network   0755 root root - -']

  $service_ensure = 'running'
  $service_enable = true
}
