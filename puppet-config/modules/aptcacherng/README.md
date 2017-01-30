# aptcacherng

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What aptcacherng affects](#what-aptcacherng-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with aptcacherng](#beginning-with-aptcacherng)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Configures apt-cacher-ng

apt-cacher-ng is a proxy/cache daemon for APT repositories. This module
configure a local server that will connect to the real repositories.

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with aptcacherng

A basic server do not need configuration:

```
include ::aptcacherng
```

## Usage

It is possible to change the default config options by overriding the
``config_options`` parameter:

```
class { '::aptcacherng':
  config_options => {
    'Port' => '1540',
  },
}
```

## Limitations

This module is mainly tested on Debian, aptcacherng is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
