# aufs

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

This module configures some systems directories (`/usr/bin` and `/usr/share`)
as an aufs overlay to a remote chroot (mounted by NFS or GPFS).

It configures mounts in `/etc/fstab` and setup a service that tries to actively
mount the overlay until the backend remote directory is available.

## Setup

This module depends on the loaded `aufs` kernel module.

## Usage

The class needs two directories the remote backend (on NFS or GPFS) and the local
squashfs.

```
class { '::aufs':
  chroot_dir   => '/gpfscluster/chroot/scibian8',,
  squashfs_dir => '/lib/live/mount/rootfs/scibian8.squashfs',
}
```

## Limitations

This module is mainly tested on Debian.

It only supports overlaying ``/usr/bin`` and ``/usr/share``.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
