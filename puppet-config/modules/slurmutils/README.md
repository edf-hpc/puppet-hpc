# slurmutils

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What slurmutils affects](#what-slurmutils-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with slurmutils](#beginning-with-slurmutils)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure Slurm additional utilities.

## Module Description

This module installs utilities for [Slurm](http://slurm.schedmd.com/) HPC
workload manager. It includes the following utililies:

* Job submit LUA script (with wckeys and QOS configuration file)
* SlurmDBD database setup utility
* SlurmDBD database backup utility
* SlurmDBD accounting users synchronization utility
* Slurm generic scripts utility

## Setup

### What slurmutils affects

The module install the packages, configuration files, eventual cronjobs and
executions of all the utilities.

### Setup Requirements

This module depends on:

* `stdlib`
* `hpclib` (for `hpclib::print_config()` and `hpclib::hpc_file()`)

### Beginning with slurm

N/A

## Usage

### Jobsubmit

The Job submit LUA script is deployed by the `jobsubmit` public class:

```
class { ::slurmutils::jobsubmit:
  conf_options => {
    CORES_PER_NODE: '28',
    ENFORCE_ACCOUNT: 'true',
  },
}
```

### SetupDB

The SlurmDBD database setup utility is deployed by the `setupdb` public class:

```
class { ::slurmutils::setupdb:
  conf_options => {
    db => {
      hosts       => 'localhost',
      user        => 'root',
      password    => 'password',
    },
    passwords => {
      slurm       => 'passwordrw',
      slurmro     => 'passwordro',
    },
    hosts => {
      controllers => 'batch1,batch2',
      admins      => 'admin1',
    },
  },
}
```

### BackupDB

The SlurmDBD database backup utility is deployed by the `backupdb` public class:

```
include ::slurmutils::backupdb
```

### Accounts synchronization

The SlurmDBD accounting users synchronization utility is deployed by the
`syncusers` public class:

```
class { ::slurmutils::syncusers:
  conf_options => {
    main => {
      org     => 'org',
      cluster => 'cluster',
      group   => 'users',
      policy  => 'global_account',
    },
    global_account => {
      name    => 'users',
      desc    => 'all users account',
    },
  },
}
```

### Generic scripts

The Slurm generic scripts utility is deployed by the `genscripts` public class:

```
include ::genscripts
```

The Slurm configuration parameters required to enable usage of the generic
scripts can be extracted from the module with the
`slurmutils::genscripts::params::genscripts_options` hash parameter.

## Limitations

This module is mainly tested on Debian, but it is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
