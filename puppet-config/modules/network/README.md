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
- IP-over-IB interfaces (either Infiniband or Intel Omni-Path)
- Ethernet bonding
- Bridges

The network module uses an interface list provided by the ``netconfig`` fact
from the ``hpclib`` module. This fact uses data from the hiera
``master_network`` to generate the interface list. It also uses data from the
``net_topology`` fact to get generic parameters for networks. 

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
}
```

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

### IPoIB

The IPoIB settings are shared between Mellanox Infiniband and Intel Omni-Path:

```
class{'::network':
  defaultgw  => '10.1.0.1',
  fqdn       => 'clnode01.cluster.hpc.example.com',
  ib_mode    => 'datagram',
  ib_mtu     => '4096',
}
```


### Ethernet Offloading

The modern ethernet cards can offload some packets computation from the main
CPU. This is generally optimal to leave these parameters alone. On some
occasion, this offloading can generate problems and it is best to disable it.

To do this with with the network module, you can provide a list of interfaces
where this offloading must be disabled:

```
class{'::network':
  eth_no_offload_ifs => ['eth3']
}
```

### Additional rotues

It is possible to setup additional routes on interfaces with the `routednet`
argument:

```
class{'::network':
  routednet  => {
    'eth0' => [
      '10.0.1.0/24',
      '10.0.2.0/24',
    ],
    'eth1' => [
      '10.0.3.0/24',
    ],
  },
}
```

## Limitations

This module is tested on Debian.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc

