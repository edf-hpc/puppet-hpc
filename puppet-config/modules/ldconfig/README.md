# ldconfig

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What ldconfig affects](#what-ldconfig-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ldconfig](#beginning-with-ldconfig)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description
Configure extra directories in system ldconfig

The module add directories to the system ldconfig, it also
configures (by default) a systemd service that will refresh ldconfig.
This service can be tied to other systemd events (like a filesystem
mount).

## Setup

### What ldconfig affects

This module sets up a new file in ``/etc/ldconfig.conf.d/`` and rebuilds
the ldconfig directly and via a service.

### Setup Requirements

This module uses stdlib, systemd and hpclib.

### Beginning with ldconfig

## Usage


```
class{ '::ldconfig':
  ldconfig_directories => [ '/opt/foo/lib' ],
  service_triggers => [ 'opt.mount' ],
}
```

The ``ldconfig_directories`` add the directories in the array to the system
ldconfig.

``service_triggerss`` takes a arrays of systemd units names, when these units
are activated, the service will be activated immediately after.

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
