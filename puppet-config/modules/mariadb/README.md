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

This module depends on the following modules:

* stdlib (for `validate_*` and `*merge` functions)
* hpclib (for `print_config()` function)
* saz-rsyslog community module if `log_to_rsyslog` parameter is true

### Beginning with mariadb

## Usage

```
class { '::mariadb':
  nodes => [
    'clbatch1',
    'clbatch2',
  ],
}
```

The module can also setup rsyslog to watch MariaDB log files by setting the
`log_to_syslog` parameter to true This feature requires the saz-rsyslog
community module to be installed. This way, the MariaDB log entries can
eventually be forwarded to a central syslog servers but obviously this has some
infrastructure requirements and proper rsyslog configuration out of the scope of
this module.

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
