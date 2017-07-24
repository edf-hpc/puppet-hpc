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
  service_overrides => {
    'ldconfig_deps_on_opt' => {
      'content' => {
        'Unit' => {
          'After' => 'opt.mount',
        },
        'Install' => {
          'WantedBy' => 'opt.mount',
        },
      },
    },
  }
}
```

The ``ldconfig_directories`` add the directories in the array to the system
ldconfig.

``service_overrides`` takes a hash of ``systemd::unit_override``
definitions. The ``unit_name`` can be ommited since it is given by
the class.

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
