# hpc_ha

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What hpc_ha affects](#what-hpc_ha-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hpc_ha](#beginning-with-hpc_ha)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Configure High-Availability resources while relying on `hpc-config` data.

## Module Description

This modules extends features from the `keepalived` module. It relies on
network configuration data coming from `hpc-config`.

## Setup

### What hpc_ha affects

Configure `keepalived` resources and sets-up notify scripts in `/etc/hpc_ha`.

### Setup Requirements

This module uses stdlib, hpclib and keepalived.

### Beginning with hpc_ha

## Usage

```
  class{ '::hpc_ha':
    vips => {
      'service' => {
        net_id      => 'wan',
        ip_address  => '172.16.3.4',
        router_id   => '342',
        auth_secret => 'S3CRET',
        master      => true,
        priority    => 100,
        prefix      => 'cl',
      }
    },
    vservs => {
      'service' => {
        ip_address        => '172.16.3.4',
        port              => '22',
        real_server_hosts => [ 'clservice1', 'clservice2' ],
        prefixes          => 'wan',
        network           => 'wan',
        vip_name          => 'public',
      } 
    }
```

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
