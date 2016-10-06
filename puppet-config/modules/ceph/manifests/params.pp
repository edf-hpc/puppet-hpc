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

class ceph::params {
  #### Module variables
  $packages        = ['ceph', 'ceph-deploy', 'radosgw']
  $packages_ensure = installed
  $services        = ['ceph', 'radosgw']
  $service_ensure  = running
  $service_enable  = true
  $config_path     = '/etc/ceph'
  $config_file     = "$config_path/ceph.conf"
  $ceph_cluster_name = 'ceph'
  $osd_path        = '/var/lib/ceph/osd'

  #### Keyrings
  $client_admin_keyring = "$config_path/ceph.client.admin.keyring"
  $bootstrap_mds_keyring = "$config_path/ceph.bootstrap-mds.keyring"
  $bootstrap_osd_keyring = "$config_path/ceph.bootstrap-osd.keyring"
  $bootstrap_rgw_keyring = "$config_path/ceph.bootstrap-rgw.keyring"
  $mon_keyring = "$config_path/ceph.mon.keyring"

  #### Default values
  $config_options_defaults = {
    'global' => {
       'fsid' => '00000000-0000-0000-0000-000000000000',
       'mon_initial_members' => 'first',
       'mon_host' => '192.168.0.1',
       'auth_cluster_required' => 'cephx',
       'auth_service_required' => 'cephx',
       'auth_client_required' => 'cephx',
    }
  }
}
