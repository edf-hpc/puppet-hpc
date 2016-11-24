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
  $packages        = [
    'ceph',
    'ceph-deploy',
    'ceph-mds',
    'ceph-mon',
    'ceph-osd',
    'radosgw',
  ]
  $packages_ensure = installed
  $ceph_user       = 'ceph'
  $services        = ['ceph']
  $service_ensure  = running
  $service_enable  = true
  $config_path     = '/etc/ceph'
  $ceph_path       = '/var/lib/ceph'
  $config_file     = "${config_path}/ceph.conf"
  $ceph_cluster_name = 'ceph'
  $osd_path        = "${ceph_path}/osd"
  $rgw_path        = "${ceph_path}/radosgw"
  $mds_path        = "${ceph_path}/mds"

  #### Keyrings
  $client_admin_keyring = "${config_path}/ceph.client.admin.keyring"
  $bootstrap_mds_keyring = "${config_path}/ceph.bootstrap-mds.keyring"
  $bootstrap_osd_keyring = "${config_path}/ceph.bootstrap-osd.keyring"
  $bootstrap_rgw_keyring = "${config_path}/ceph.bootstrap-rgw.keyring"
  $mon_keyring = "${config_path}/ceph.mon.keyring"
  $osd_keyring_file = "${ceph_path}/osd/${ceph_cluster_name}-%s/keyring"
  $mds_keyring_file = "${ceph_path}/mds/${ceph_cluster_name}-${::hostname}/keyring"
  $rgw_keyring_file = "${ceph_path}/radosgw/${ceph_cluster_name}-rgw.${::hostname}/keyring"

  #### Services
  $mds_service = "ceph-mds@${::hostname}"
  $mon_service = "ceph-mon@${::hostname}"
  $osd_service = 'ceph-osd@%s'
  $rgw_service = "ceph-radosgw@rgw.${::hostname}"

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
