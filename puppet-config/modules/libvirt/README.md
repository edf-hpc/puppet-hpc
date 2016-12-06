# libvirt

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What libvirt affects](#what-libvirt-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with libvirt](#beginning-with-libvirt)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)


## Module Description

Configures libvirt servers and setup resources (network, storage pools, secrets...).

The base class configures the system daemon and defined resource type permit to
add configuration dynamically:
- network
- storage pool
- secrets

## Setup

### What libvirt affects

Only affect the libvirt service and its configuration.

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with libvirt

## Usage

The usage below shows the main configuration tested: a few bridged networks and
a Ceph RBD storage pool.

```
include ::libvirt

::libvirt::network {'administration':
  mode      => 'bridge',
  interface => 'br0',
}
::libvirt::network {'management':
  mode      => 'bridge',
  interface => 'br0',
}

::libvirt::network {'wan':
  mode      => 'bridge',
  interface =>'br2',
}

::libvirt::pool {'rbd-pool':
  type  => 'rbd',
  hosts => [ 
    'clservice1',
    'clservice2',
    'clservice3',
  ],
  auth => {
    'type'     => 'ceph',
    'username' =>' libvirt',
    'uuid'     => '07f089e4-fb59-4eb4-9b27-3030115006a0',
  },
}

::libvirt::secret {'client.libvirt':
  type  => 'ceph',
  uuid  => '07f089e4-fb59-4eb4-9b27-3030115006a0',
  value => '0ExHtTqe+EP9zhqJQ0QTn2bPu4TVkbj8XqkWfg==',
}
```

## Limitations

This version supports a small number of combination supported by the underlying
libvirt.

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
