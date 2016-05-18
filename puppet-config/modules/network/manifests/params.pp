#
class network::params {

  $ib_udevrl       = '/etc/udev/rules.d/50-infiniband-permissions.rules'
  $ib_cfg          = '/etc/infiniband/openib.conf'
  case $::osfamily {
    'Debian': {
## Hostname
      $aug_hname   = '/files/etc/hostname'
      $aug_changes = "set hostname ${::hostname}"
## Interfaces
      $cfg         = '/etc/network/interfaces'
      $bd_pkgs     = ['ifenslave-2.6']
      $ib_pkgs     = ['ibverbs-utils', 'infiniband-diags', 'libmlx4-1',
                      'libmlx5-1','libibverbs1','libibmad5','libibumad3',
                      'dapl2-utils','mlnx-ofed-kernel-utils',
                      'mlnx-ofed-kernel-modules','knem-kernel-module','mxm']
    }
    'Redhat': {
## Hostname
      $aug_hname   = '/files/etc/sysconfig/network'
      $aug_changes = "set HOSTNAME ${::hostname}"
## Interfaces
      $cfg         = '/etc/sysconfig/network-scripts/ifcfg'
      $bd_pkgs     = ['net-tools']
      $ib_pkgs     = ['ar_mgr','bupc','cc_mgr','dapl','dapl-utils',
                      'dump_pr','fca','hcoll','ibacm','ibdump',
                      'ibutils','ibutils2','infiniband-diags',
                      'infiniband-diags-compat','kmod-iser',
                      'kmod-kernel-mft-mlnx','kmod-knem-mlnx',
                      'kmod-mlnx-ofa_kernel','kmod-srp',
                      'knem-mlnx','libibmad','libibprof',
                      'libibumad','libibverbs','libibverbs-utils',
                      'libmlx4','libmlx5','librdmacm',
                      'librdmacm-devel','librdmacm-utils','mft',
                      'mlnx-ofa_kernel','mlnx-ofa_kernel-devel',
                      'mpfr','mstflint','mxm','ofed-scripts',
                      'perftest','qperf', 'rds-tools']
    }
    default: {}
  }

  $systemd_tmpfile           = '/etc/tmpfiles.d/openibd.conf'
  $systemd_tmpfile_conf      = ['d    /run/network   0755 root root - -']
  $ifup_hotplug_service      = 'ifup-hotplug.service'
  $ifup_hotplug_service_file = "/etc/systemd/system/${ifup_hotplug_service}"
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
  $openib_cfg0 = {
    'onboot'                       => 'yes',
    'node_desc'                    => 'ib$(hostname -s)',
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

  # The code below is used to generate a new hash that contains the results of
  # merge the variables $net_ib_pkgs and $net_bd_pkgs
  # This hash is used by create_resources to install all packages in the class
  # network::commons
  $pkgs            = { }
  $packagescode    =  inline_template('<% @ib_pkgs.concat(@bd_pkgs).each do |pk| ; @pkgs[pk] = { "name" => pk,} ; end %>')

}
