# iscdhcp

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What iscdhcp affects](#what-iscdhcp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with iscdhcp](#beginning-with-iscdhcp)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description

Configure a DHCP server

The modules installs and configure the ISC DHCP server. It uses hashes passed as
argument to fill the configuration files.

## Setup

### What iscdhcp affects

The server sets up a DHCP server.

### Setup Requirements

This module uses stdlib and `hpclib`.

### Beginning with iscdhcp

## Usage

The class builds configuration with the content of `boot_params` and `dhcp_config`.

Entries are sorted in the right `iscdhpc::include` by looking in which subnet range the node goes.

```
class{'::iscdhcp':
  my_address      => '10.1.2.11',
  peer_address    => '10.1.2.12',
  default_options => [
    'INTERFACES=br0',
  ],
  global_options  => [
    'dhcp-max-message-size 2048',
    'space ipxe',
  ],
  sharednet       => {
    'name' => 'clusternet',
    'subnet' => [
      {
        'name'                => adm,
        'network'             => '10.1.2.0',
        'netmask'             => '255.255.255.0',
        'domain-name'         => 'cluster.hpc.example.com',
        'domain-name-servers' => '10.1.2.254, 10.1.2.253',
        'broadcast'           => '10.1.2.255',
      },
      {
        'name'                => bmc,
        'network'             => '10.1.3.0',
        'netmask'             => '255.255.255.0',
        'domain-name'         => 'cluster.hpc.example.com',
        'domain-name-servers' => '10.1.0.254, 10.1.0.253',
        'broadcast'           => '10.1.3.255',
      },
    },
  },
  includes        => {
    'adm-subnet' => {
      'pool_name'   => 'subnet',
      'subnet_name' => 'adm',
      'tftp'        => true,
      'pool'        => {
        'use-host-decl-names' => 'on',
        'deny'                => 'unknown-clients',
        'max-lease-time'      => '1800',
        'range'               => '10.1.2.1 10.1.2.254',
        'include'             => '/etc/dhcp/adm_subnet',
      },
    },
    'bmc-subnet' => {
      'pool_name'   => 'subnet',
      'subnet_name' => 'bmc',
      'tftp'        => false,
      'pool'        => {
        'use-host-decl-names' => 'on',
        'deny'                => 'unknown-clients',
        'max-lease-time'      => '1800',
        'range'               => '10.1.3.1 10.1.3.254',
        'include'             => '/etc/dhcp/bmc_subnet',
      },
    },
  },
  bootmenu_url    => 'http://web-boot.service.virtual:8125/cgi-bin/bootmenu.py?node=${hostname}',
  dhcp_config     => {
    'clcn001" => {
      'macaddress' => '03:00:68:37:e3:c3',
      'ipaddress'  => '10.1.2.64',
    },
    'bmcclcn001' => {
      'macaddress' => '03:00:68:37:f9:ea',
      'ipaddress'  => '10.1.3.64',
    },
  },
  boot_params     => {
    'clservice[1-4],cladmin1' => {
      'ipxebin' => 'ipxe_noserial.bin',
    },
    'clcn[001-064]' => {
      'ipxebin' => 'ipxe_noserial.bin',
    },
  },
}
```



## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
