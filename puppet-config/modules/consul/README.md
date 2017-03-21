# consul

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What consul affects](#what-consul-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with consul](#beginning-with-consul)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure a consul agent. Can be configured as a server or a client.

## Module Description

This module can install and configure a consul server. It provides ressources
to defines consoles to monitor.

## Setup

### What consul affects

It instal packages necessary to run a consul agent and configure the file
/etc/conman.conf.

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with consul

## Usage

To have Puppet install Consul in server mode, declare the consul class:

```
class { '::consul': }
```

Client mode must be specified:

```
class { '::consul':
  mode => 'client',
}
```

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
