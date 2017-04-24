# hpc_backup

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What hpc_backup affects](#what-hpc_backup-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hpc_backup](#beginning-with-hpc_backup)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Configures a backup system for puppet-hpc

Some configuration element in a puppet-hpc cluster needs to be backed up. This
module provides tools to:

 * Collect some directory periodically and put them on the machine where the
   module is installed 
 * Dump switches configuration

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with hpc_backup

To configure backup, you need a list of sources. This list is a set of roles
and source directories. The module assumes the target host can connect to the
source host through SSH without a password.

## Usage

### Class: collect_dir


```
class { '::hpc_backup::collect_dir':
  sources => {
    'root_home' => {
      source_roles => ['frontend', 'admin'],
      source_dir   => '/root',
    },
  }
  base_dir => '/var/backups/cluster',
}
```

Source parameters:
 * source_roles: Array of roles to include in the periodical backups
 * source_dir: Path of the source directory to backup

On the local machine, the target directories will have the name:

```
<base_dir>/<hostname>_<source_name>
```

Files disappearing from the source are automatically cleaned (``delete`` parameter).

### Class: switches

```
class { '::hpc_backup::switches':
  sources => {
    'exos' => {
      source_nodeset   => 'clswethadm[1-5]',
    },
  }
  base_dir => '/var/backups/hpc-hardware',
}
```

The type must be supported by a backup script of the form:
``/usr/bin/backup-switches-exos``.

## Limitations

This module is mainly tested on Debian, hpc_backup is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
