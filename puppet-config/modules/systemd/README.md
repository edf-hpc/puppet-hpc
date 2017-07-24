# systemd

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What environment affects](#what-environment-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with environment](#beginning-with-environment)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description
Manage units and other systemd features

This module provides some classes and types that extends the basic
interface provided by the systemd backend of the `service` resource.
It can also configures some other features of systemd:
 - systemd itself
 - module loading during boot

## Setup

### What environment affects

Add unit configuration and other configuration files.

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with systemd

## Usage

### Class: ``systemd``

Can be used to set systemd options in ``/etc/systemd/systemd.conf``.

```
class { '::systemd':
  system_manager_options => {
    'ShutdownWatchdogSec' => '0',
  }
}
```

### Resource: ``modules_load``

Load a module during boot:

```
::systemd::modules_load { 'ipmievd':
  data => [ 'ipmi_si', 'ipmi_devintf' ],
}
```

### Resource: ``unit_override``

Permits to define drop-ins files, this extends and overrides some specific
values from a systemd unit without entirely replacing the original
definition. It can be used to set dependencies or change limits for
example.

```
::systemd::unit_override { 'openldap_limits':
  unit_name => 'slapd.service',
  content   => {
    'Service' => {
      'LimitNOFILE' => '8192',
    },
  }
}

::systemd::unit_override { 'ldconfig_deps':
  unit_name => 'ldconfig-refresh.service',
  content   => {
    'Unit' => {
      'After' => 'opt.mount',
    },
    'Install' => {
      'WantedBy' => 'opt.mount',
    },
  }
}
```

NB: As with other settings from the ``Install`` section, in normal systemd
unit files. The unit must be re-activated after the override is defined for
the ``Install`` section options to take effect.

### Resource: ``unit_state``

Ensure the systemd unit has expected state (disabled, enabled, masked).

## Limitations

This module is mainly tested on Debian.

The `service` class is tested on RedHat (RHEL, CentOS...).

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
