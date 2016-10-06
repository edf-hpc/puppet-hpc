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

class ceph::config inherits ceph {

  if has_key($::ceph::osd_config, $::hostname) {
    $ceph_id = $::ceph::osd_config[$::hostname]['id']
    $mountpoint = "${::ceph::osd_path}/${::ceph::ceph_cluster_name}-${ceph_id}"
    file { $mountpoint:
      ensure  => 'directory',
    }

    mount { $mountpoint :
      ensure   => 'mounted',
      device   => $::ceph::osd_config[$::hostname]['device'],
      fstype   => auto,
      require  => File[$mountpoint],
    }
  }

  hpclib::print_config { $::ceph::config_file :
    style     => 'ini',
    data      => $::ceph::_config_options,
    notify    => Class['::ceph::service'],
  }

  hpclib::print_config { $::ceph::mon_keyring :
    style     => 'ini',
    data      => $::ceph::keyrings['ceph.mon.keyring'],
    notify    => Class['::ceph::service'],
  }

  hpclib::print_config { $::ceph::client_admin_keyring :
    style     => 'ini',
    data      => $::ceph::keyrings['client.admin.keyring'],
    notify    => Class['::ceph::service'],
  }

  hpclib::print_config { $::ceph::bootstrap_mds_keyring :
    style     => 'ini',
    data      => $::ceph::keyrings['ceph.bootstrap-mds.keyring'],
    notify    => Class['::ceph::service'],
  }

  hpclib::print_config { $::ceph::bootstrap_osd_keyring :
    style     => 'ini',
    data      => $::ceph::keyrings['ceph.bootstrap-osd.keyring'],
    notify    => Class['::ceph::service'],
  }

  hpclib::print_config { $::ceph::bootstrap_rgw_keyring :
    style     => 'ini',
    data      => $::ceph::keyrings['ceph.bootstrap-rgw.keyring'],
    notify    => Class['::ceph::service'],
  }

}
