# network

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What dns affects](#what-network-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with dns](#beginning-with-network)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description
Configures the network on this system

Configures the network interfaces on this system. This module configures:

- Hostname
- Routing (default gateway and static routes)
- Ethernet interfaces
- Ethernet bonding
- Bridges
- Intel Omni-Path
- Mellanox Infiniband

Note: Intel Omni-Path and Mellanox Infiniband are mutually exclusive.

The network module uses an interface list provided by the ``netconfig`` fact
from the ``hpclib`` module. This fact uses data from the hiera
``master_network`` to generate the interface list. It also uses data from the
``net_topology`` fact to get generic parameters for networks. 

On Debian, the module configures all interfaces as manual, it relies on a
special service it sets up (``ifup-hotplug``) to bring the interfaces up during
boot or after changing the configuration.

## Setup

### What network affects

On Debian, this module takes over ``/etc/network/interfaces`` configuration file.

### Setup Requirements

This module uses hpclib, it particularly uses the ``netconfig`` fact to get the
interface list.

### Beginning with network
Basic usage is:

```
class{'::network':
  defaultgw  => '10.1.0.1',
  fqdn       => 'clnode01.cluster.hpc.example.com',
  ib_enable  => false,
  opa_enable => false,
}
```

The parameters ``ib_enable`` and ``opa_enable`` can be ommited. When they are
true, they configure Mellanox Infiniband and Intel Omni-Path respectively.

## Usage

### Bonding
Bonding is configured by passing bonding options as a hash:

```
class{'::network':
  bonding_options => {
    'bond0' => {
      'slaves'  => [ 'eth0', 'eth1' ],
      'options' => 'mode=active-backup primary=eth0',
    },
    'bond1' => {
      'slaves'  => [ 'eth2', 'eth3' ],
      'options' => 'mode=active-backup primary=eth2',
    },
  },
}
```

### Bridges

Bridges are configured by passing bridge options as a hash. If the
bridged port does not exists in the netconfig fact, it will be added
automatically when the configuration is written.

```
class{'::network':
  bridge_options => {
    'br0' => {
      'ports' => ['eth0'],
      'description' => 'administraton network on service and nas nodes',
    },
    'br2':
      'ports' => ['bond2'],
      'description' => 'WAN network on service nodes',
    },
  },
}
```

### Intel Omni-Path

When enabled, Intel Omni-Path will install the relevant packages and load the
modules. Interface configuration (``ib0``) is done like any other interface.

Intel Omni-Path does not configures the ``rdma`` service but directly
configures ``irqbalance`` and systemd modules load.

```
class{'::network':
  defaultgw  => '10.1.0.1',
  fqdn       => 'clnode01.cluster.hpc.example.com',
  ib_enable  => false,
  opa_enable => true,
}
```

### Mellanox Infiniband

When enabled, Mellanox Infiniband will install the relevant packages and load
the modules. Interface configuration (``ib0``) is done like any other
interface.

Mellanox Infiniband configures the ``openib`` service.

```
class{'::network':
  defaultgw  => '10.1.0.1',
  fqdn       => 'clnode01.cluster.hpc.example.com',
  ib_enable  => true,
  opa_enable => false,
}
```

### IPoIB

The IPoIB settings are shared between Mellanox Infiniband and Intel Omni-Path:

```
class{'::network':
  defaultgw  => '10.1.0.1',
  fqdn       => 'clnode01.cluster.hpc.example.com',
  ib_enable  => true,
  opa_enable => false,
  ib_mode    => 'datagram',
  ib_mtu     => '4096',
}
```

## Limitations

This module is tested on Debian.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc

