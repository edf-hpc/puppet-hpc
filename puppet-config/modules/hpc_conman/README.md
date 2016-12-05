# hpc_conman

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What hpc_conman affects](#what-flexlm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hpc_conman](#beginning-with-flexlm)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Set up conman in a cluster using `hpc-config` 

## Module Description

This modules uses `hpc-config` conventions to create the conman configuration
suitable for a HPC cluster.

## Setup

### What hpc_conman affects

Change the conman configuration.

### Setup Requirements

This module uses the module hpclib from edf-hpc. It also relies on the
service/role definition from `hpc-config`.

### Beginning with hpc_conman

## Usage

On the client:
```
include ::hpc_conman::client
```

On the server:
```
class{ "::hpc_conman::server":
  roles => [ 'service', 'cn', 'front' ],
  prefix => 'bmc'
}
```

If the conman server must only be up when a specific HA VIP is active, it can
be specified with the `vip_name` parameter.


## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
