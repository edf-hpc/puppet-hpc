# opafm

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

The module installs and configure the Intel OmniPath (OPA) Fabric Manager (FM),
also known as OPA FM.

It can eventually enable the Fabric Executive (FE) that is notably used by
Intel FM GUI to get data from the FM through TLS/SSL.

## Setup

### What opafm affects

* OPA Fabric Manager packages
* OPA Fabric Manager XML formatted configuration file
* OPA Fabric Manager service

### Setup Requirements

This module depends in:

* `stdlib` module (`validate_*()` functions)
* `hpclib` module (`hpc_file()` function)

### Beginning with opafm

The module is able to define device groups (such as OPA switches groups) into
the OPA FM XML configuration file and then set Performance Manager (PM) port
groups on these device groups. This way, the performances of the groups of
switches can be monitored with tools such as `opatop` or FM GUI.

To define the device groups, it is required to gather the GUIDs of the switches
before anything. Once the network fibers and cables are plugged, the switches
GUIDs can be retrieved with the following command:

```
# opaextractsellinks
```

This command dumps the list of inter-switches links along with the GUIDs of the
switches. If the switches have been properly labelled with `opaswitchadmin`, the
output is hopefully human-readable. Otherwise, ask the hardware vendor for the
GUIDs.

## Usage

The `opafm` has only one public class. This public class can be instanciated in
two main ways, either by giving in arguments:

* Individual parameters of the OPA Fabric Manager configuration file. This way,
  the configuration file is generated based on a template and the arguments values.
* The URL to a full OPA Fabric Manager XML configuration file.

Here is an example of public class instanciation with individual parameters:

```
class { '::opafm':
  fe_enable      => true,
  fe_sslsecurity => true,
  devicegroups   => {
    'group1' => {
      comment   => 'cluster switches group 1',
      nodeguids => [ '0x0134567deadbeef1',
                     '0x0134567deadbeef2',
                     '0x0134567deadbeef3', ],
    },
    'group2' => {
      comment   => 'cluster switches group 2',
      nodeguids => [ '0x0134567deadbeef4',
                     '0x0134567deadbeef5',
                     '0x0134567deadbeef6',
                     '0x0134567deadbeef7', ],
    },
    'group3' => {
      comment => 'cluster switches group 3',
      nodeguids => [ '0x0134567deadbeef8',
                     '0x0134567deadbeef9',
                     '0x0134567deadbeefA', ],
    },
  },
  pmportgroups   => {
    'group1' => {
      monitor => 'group1',
      enable  =>  '1',
     },
    'group2' => {
      monitor => 'group2',
      enable  => '1',
    },
    'group3' => {
      monitor => 'group3',
      enable  => '1',
    },
  },
}

```

With this class instanciation, the Fabric Engine will be enabled (typically for
FM GUI) with SSL security enhancement. Three devices groups of switches are
defined. All these groups are then assigned to PM groups.

To give URL to a full OPA Fabric Manager XML configuration file, use the
`config_source` argument:

```
class { '::opafm':
  config_source => 'http://s3-system.service.virtual:7480/hpc-config/%{environment}/latest/files/opa/opafm.xml',
}
```

If the `config_source` argument is defined, its value takes precedence over the
individual parameters.

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
