# hpc_nfs

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What hpc_nfs affects](#what-hpc_nfs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hpc_nfs](#beginning-with-hpc_nfs)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Configures High-Availability failover for NFS server

This module sets up a simple NFS HA system for a two node cluster with. It
relies on the same system Keepalived system as other HA services on the
puppet-hpc configuration.

This is a simple setup that requires a somwhat exclusive uses of the hosts. The
hosts can be fenced (killed) at any moment. Operation also requires some
precautions.

The system locks the storage shared between the nodes by writing a tag on the
LVM volume group. When a node becomes the backup node, it removes its tag. When
the tags disappeard, the new master know the storage can safely be used. If the
tag is not removed after a minute, the backup node is fenced and the tag is
forcibly removed by the new master.

A script running as a cron every minutes checks that the node with the tag is
healthy. If it is not, keepalived is killed and the partner should then become
master.

## Setup

### Setup Requirements

This module uses:
  - stdlib,
  - hpclib,
  - hpc_ha,
  - logrotate

This module relies on the VIP defined in the puppet-hpc configuration.

### Beginning with hpc_nfs

To use the ha_server class, these systems must be configured separately:
 - The NFS exports
 - The HA (keepalived) VIP
 - Clara for the fencing

In puppet-hpc, both theses systems can be configured with hiera:


NFS:

```

## Mount points
profiles::filesystem::directories:
  '/storage':      {}
  '/storage/data': {}

## Mount
profiles::filesystem::mounts:  
  '/storage/data':
    ensure: 'present'
    atboot:  false
    device:  '/dev/mapper/cluster--san--a-data'
    fstype:  'ext4'
    options: 'noauto'

## NFS Exports
#/storage        10.100.0.0/255.255.248.0(rw,sync,fsid=0,crossmnt,no_subtree_check)
#/storage/data   10.100.0.0/255.255.248.0(rw,sync,no_subtree_check,no_root_squash)
profiles::nfs::to_export:
  exportroot:
    export: '/storage'
    clients:
      - hosts:   '10.100.0.0/255.255.248.0'
        options: 'rw,sync,fsid=0,crossmnt,no_subtree_check'
  data:
    export: '/storage/data'
    clients:
      - hosts:   '10.100.0.0/255.255.248.0'
        options: 'rw,sync,no_subtree_check,no_root_squash'

nfs::server::service_manage: false

```

The important part for NFS is to not manage the service that will be managed by
keepalived notify scripts.

It should also be noted that the `atboot` parameter on the mount resource is
false, mount is also handled by the keepalived notify scripts.

VIP:

```
keepalived::service_manage: false

vips:
  nas:
    network:    'administration'
    ip:         '10.100.2.40'
    hostname:   'clnas'
    router_id:  174
    master:     'clnas1'
    members:    'clnas[1,2]'
    secret:     'SECRET'
    notify:     {}
    advert_int: '5'
```

The keepalived service should not be managed by puppet to authorize manual
operation.

The notify script is set by the `ha_server` class.

The matching `ha_server` parameters are:

```
hpc_nfs::ha_server::lvm_vg:         'cluster-san-a'
hpc_nfs::ha_server::fence_method:   'CLARA_IPMI'
hpc_nfs::ha_server::vip_name:       'nas'
hpc_nfs::ha_server::multipath_name: 'VOL-CLUSTER-A'
hpc_nfs::ha_server::v4recovery_dir: '/storage/data/nfs/v4recovery'
hpc_nfs::ha_server::mount_points:
  - '/storage/data'
```

## Usage

### Class: ha_server


```
class { '::hpc_nfs::ha_server':
}
```

## Limitations

This module is mainly tested on Debian, hpc_nfs is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
