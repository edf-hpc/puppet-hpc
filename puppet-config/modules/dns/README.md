# dns

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What dns affects](#what-dns-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with dns](#beginning-with-dns)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Configure a DNS server (forward and authoritative) and system client.

## Module Description

This module can install and configure a DNS server (bind) and configure clients.

Zones must be fully provided as a hash.

## Setup

### What dns affects

The client takes over defining the `resolv.conf` file.

The server sets up a Bind server.

### Setup Requirements

This module uses stdlib.

### Beginning with dns

## Usage

On a client:

```
class { '::dns::client':
  domain      => "cluster.hpc.example.com",
  nameservers => [ '192.168.1.254', '192.168.1.253' ],
}
```

On a server:

```
class { '::dns::server':
  config_options => {
    'forwarders'        => [ '10.1.2.1', '10.1.1.1' ],
    'listen-on'         => [
      '127.0.0.1',
      '192.168.1.254',
      '192.168.1.253'
    ],
    'dnssec-validation' => 'no'
  },
  zones => {
    "cluster.hpc.example.com" =>  {
      "type" => "master",
      "entries" => [
         {
           "owner" => "@",
           "proto" => "IN",
           "type"  => "NS",
           "data"  => "cladmin1.cluster.hpc.example.com."
         },
        {
           "owner" => "@",
           "proto" => "IN",
           "type"  => "A",
           "data"  => "127.0.0.1"
         },
         {
           "owner" => "cladmin1",
           "proto" => "IN",
           "type"  => "A",
           "data"  => "10.1.16.11"
         }
      ]
    },
  }
}
```

On a real server, the zones hash must fully describe all forward and reverse
zones. If the configuration is using `hpc-config`, it should use the function
`hpc_dns_zones` from the `hpclib` module.

The server also support a virtual zone for services. If the `virtual_relay`
argument is true, all the requests to the `virtual_zones` are relayed to an
external DNS server, typically DNS interface of the Consul discovery service.
If `virtual_relay` is false, a virtual zone is declared and managed by bind with
the entries given in `virtual_entries` array.

## Limitations

dns::client is tested on Debian and RedHat (RHEL, CentOS).

dns::server is only tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
