# opentracker

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with opentracker](#beginning-with-opentracker)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Install and configure opentracker  server

OpenTracker is a Bittorrent tracker.

## Setup

### Setup Requirements

The module uses the following modules:

* edfhpc-hpclib

The module uses the hpclib ``hostfile`` template to convert node names to IP
addresses.

### Beginning with opentracker

```
class{'opentracker':
  admin_node    => 'cladmin1',
  tracker_nodes => ['clp2p1', 'clp2p2'],
}
```

## Usage

The base usage is enough for nearly all cases, the seeders automatically
register themselves with this tracker.

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
