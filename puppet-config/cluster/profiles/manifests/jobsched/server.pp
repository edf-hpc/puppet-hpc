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

# Job scheduler server
#
# A generic configuration is defined in
# ``puppet-hpc/hieradata/common.yaml", in your own hiera files you could
# just redefine, the following values:
#
# ## Common
# ```
# slurm_primary_server:         "%{hiera('cluster_prefix')}%{::my_jobsched_server}1"
# slurm_secondary_server:       "%{hiera('cluster_prefix')}%{::my_jobsched_server}2"
# ```
#
# ## Slurm controller
#
# ```
# slurmutils::jobsubmit::conf_options:
#   CORES_PER_NODE: '28'
#   ENFORCE_ACCOUNT: 'true'
# ```
#
# ## SlurmDBD
#
# ```
# slurmdbd_slurm_db_password: 'SLURM_PASSWORD_OVERRIDEME_IN_EYAML'
# slurmdbd_slurmro_db_password: 'SLURMRO_PASSWORD_OVERRIDEME_IN_EYAML'
#
# slurm::dbd::config_options:
#   DbdHost:           "%{hiera('slurm_primary_server')}"
#   DbdBackupHost:     "%{hiera('slurm_secondary_server')}"
#   SlurmUser:         "%{hiera('profile::jobsched::slurm_user')}"
#   StorageHost:       'localhost'
#   StorageUser:       'slurm'
#   StoragePass:       "%{hiera('slurmdbd_slurm_db_password')}"
#
# slurmutils::setupdb::conf_options:
#   db:
#     hosts:       'localhost'
#     user:        'debian-sys-maint'
#     password:    "%{hiera('mariadb::mysql_root_pwd')}"
#   passwords:
#     slurm:       "%{hiera('slurmdbd_slurm_db_password')}"
#     slurmro:     "%{hiera('slurmdbd_slurmro_db_password')}"
#   hosts:
#     controllers: "%{hiera('slurm_primary_server')},%{hiera('slurm_secondary_server')}"
#     admins:      "%{hiera('cluster_prefix')}admin1"
# ```
#
# ## Hiera
#
# * profiles::jobsched::slurm_config_options (`hiera_hash`) Content of the slurm
#         configuration file.
# * profiles::jobsched::server::sync_options (`hiera_hash`) Content of SlurmDBD
#         accounting users synchronization utility configuration file.
# * profiles::jobsched::server::ceph::enabled (`hiera`) Configure the ceph
#         StateSaveDir for this slurm instance
# * profiles::jobsched::server::ceph::keys (`hiera_hash`) Keys to define on this
#         node for CephFS kernel mounts
# * profiles::jobsched::server::ceph::mounts (`hiera_hash`) Mounts to use for
#         CephFS space
class profiles::jobsched::server {

  # slurm components

  $slurm_config_options = hiera_hash('profiles::jobsched::slurm_config_options')

  class { '::slurm':
    config_options => $slurm_config_options
  }

  $slurmdbd_config_options = hiera_hash('profiles::jobsched::server::slurmdbd_config_options')

  class { '::slurm::dbd':
    config_options => $slurmdbd_config_options,
  }

  include ::slurm::ctld
  include ::munge

  # slurm utilities

  $sync_options = hiera_hash('profiles::jobsched::server::sync_options')
  class { '::slurmutils::syncusers':
    conf_options => $sync_options,
  }
  include ::slurmutils::jobsubmit
  include ::slurmutils::backupdb
  include ::slurmutils::setupdb

  # optional slurmctld spool on CephFS
  if hiera('profiles::jobsched::server::ceph::enabled') {
    $ceph_keys = hiera_hash('profiles::jobsched::server::ceph::keys', {})
    $ceph_mounts = hiera_hash('profiles::jobsched::server::ceph::mounts')
    class { '::ceph::posix::client':
      keys   => $ceph_keys,
      mounts => $ceph_mounts,
    }
    Class['::ceph::posix::client'] -> Class['::slurm::ctld']
  }

  Class['::slurm'] -> Class['::slurm::ctld']
  Class['::munge::service'] -> Class['::slurm::dbd::service'] -> Class['::slurm::ctld::service']

}
