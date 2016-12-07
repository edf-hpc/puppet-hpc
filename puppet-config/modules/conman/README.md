# conman

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What coman affects](#what-conman-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with conman](#beginning-with-conman)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install a Conman server and provides ressources to configure it.

## Module Description

This module can install and configure a conman server. It provides ressources
to defines consoles to monitor.

## Setup

### What conman affects

It install packages necessary to run a conman server and configure the file
/etc/conman.conf.

### Setup Requirements

This module uses stdlib ans hpclib.

### Beginning with conman

## Usage

To have Puppet install Conman with the default parameters, declare the conman class:

```
class { 'conman': }
```

## Configuring a console

Most of the time, you need to configure a console to monitor.
You can configure a console using IPMI or TELNET protocols:

```
conman::console_ipmi { 'host_to_monitor':
        host => 'host_to_monitor'
}
conman::console_telnet { 'host_to_monitor':
        host => 'host_to_monitor',
        port => '3463',
}
```

## Changing default options

Default serveur configuration can be changed with the 'global_options' and 
'server_options' hash:

```
class { 'conman':
  global_options => {
    'logdir'    => '/var/log/conman',
    'pidfile'   => '/var/run/conmand.pid',
    'syslog'    => 'local1',
    'timestamp' => '5m',
  }
  server_options => {
    'logopts'  => 'lock,sanitize,timestamp',
    'log'      => '%N/console.log',
    'seropts'  => '115200,8n1',
    'ipmiopts' => 'U:admin,P:admin',
  }
}
```
It is possible to change only one parameter, as the options passed to the 
class are merged with the default options.

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
