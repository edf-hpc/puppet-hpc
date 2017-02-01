# proftpd

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What proftpd affects](#what-proftpd-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with proftpd](#beginning-with-proftpd)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Configures a ProFTPd server

The module installs a ProFTPd service, it can also setup a cron to
automatically stop the service at a specific time. The goal of this feature is
to start the server when needed without worrying about it staying up
indefinitely.

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with proftpd

## Usage

To use the auto-stop feature:

```
class { '::proftpd':
  auto_stop      => true,
  auto_stop_hour => '21',
  auto_stop_min  => '00',
}
```

## Limitations

This module is mainly tested on Debian, proftpd is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
