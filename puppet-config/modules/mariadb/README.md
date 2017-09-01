# mariadb

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What mariadb affects](#what-mariadb-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mariadb](#beginning-with-mariadb)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

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

By default, the module also setup some parameters for security hardening
purpose. Notably, it fixes the following settings:

* `max_user_connections` to 100 (default is 0 ie. unlimited), in order to
  prevent one user from grabbing all 151 available `max_connections` (default
  MariaDB value).
* `secure_file_priv` is set to an empty value in order to disable potentially
  dangerous command `LOAD DATA INFILE`.
* the client histfile `~/.mysql_history` is disabled by default.

It is obviously possible to change these settings, for example with the
following parameters:

```
class { '::mariadb':
  disable_histfile => false,
  galera_conf_options => {
    mysqld => {
      'secure_file_priv'     => '/',
      'max_user_connections' => '0',
    }
  }
}
```

The module also support setting SSL on with key and cert on server-side and
automatic server certificate verification on client-side. This is disabled by
default. The `enable_ssl` argument must be set to true in order to enable this
optional feature:

```
class { '::mariadb':
  enable_ssl => true,
}
```

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
