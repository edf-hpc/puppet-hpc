# mariadb

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What mariadb affects](#what-mariadb-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mariadb](#beginning-with-mariadb)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description

Installs and configure a mariadb/galera HA cluster

The main class accepts `nodes` parameter that allow to setup a
High-Availability, master/master SQL cluster.

## Setup

### What mariadb affects

Controls all mysql/mariadb configuration files.

### Setup Requirements

This module uses stdlib.

### Beginning with mariadb

## Usage

```
class{'::mariadb':
  nodes => [
    'clbatch1',
    'clbatch2',
  ],
  mysql_root_pwd => 'passW0rd',
}
```

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
