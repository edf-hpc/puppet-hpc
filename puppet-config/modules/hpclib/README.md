# hpclib

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What hpclib affects](#what-hpclib-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hpclib](#beginning-with-hpclib)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Facts, function and resources used to build the HPC configuration.

## Module Description

This module provides building blocks to:

* Extract data from the cluster definition in hiera
* Define functions and resources used by the rest of the configuration

## Setup

### What hpclib affects

* Define facts

### Setup Requirements

This module requires pluginsync to make facts work in an agent/master
configuration. 

The module require ``clustershell`` to be installed on the master or on all
nodes if you are masterless. 

### Beginning with hpclib

hpclib facts relies on a cluster definition in hiera:
https://github.com/edf-hpc/puppet-hpc/wiki/Cluster%20Definition

## Usage

This module is not used directly, but can be used by *profiles* or non generic
modules to get the cluster definition from facts and functions.

Resources can be used by generic modules to implement some constructs often
found like:

* Configuration files
* Systemd services
* Systemd tmpfiles
* Sysctl settings

### Defined types

#### Defined type: `print_config`

{file:hpclib/print_config hpclib::print_config


##### Styles

###### entries

For ``ini`` and ``keyval``, an entry is a structure that can have the following forms:

**Direct string**:

```
"key" => "value"
```

If the separator is ``=``, it will be written as:

```
key=value
```

**Commented value**:

```
"somekey" => { 
  "comment" => "Some Comment",
  "value"   => "somevalue",
}
```

If the separator is ``=``, it will be written as:

```
#Some Comment
somekey=somevalue
```

Comment can be undefined or ommited.

#####``ini``:
``data`` is a hash of sections pointing to an array of entries

```
"SectionA" => {
  "key1" => {
     "value"   => "a,b,c,d",
     "comment" => "Ordered letters",
   },
  "key2" => {
     "value"   => "1,2,3,4",
     "comment" => "Ordered numbers",
   }
},
"SectionB" => {
  "key1" => {
     "value"   => "a,c,d",
     "comment" => "Ordered letters",
  },
  "key3" => {
     "value"   => "1,2",
     "comment" => "Ordered numbers",
   },
}
```

If the separator is ``=``, it will be written as:

```ini
[SectionA]
#Ordered letters
key1=a,b,c,d
#Ordered numbers
key2=1,2,3,4

[SectionB]
#Ordered letters
key1=a,c,d
#Ordered numbers
key3=1,2

```

#####``keyval``:
``data`` is a hash of entries.

#####``linebyline``:
``data`` is an array of lines dumped into the file

#####``yaml``:
Dump the content of ``data`` as a YAML file.


### Facts

#### Fact: ``mycontext`` (context)

String giving the current execution context, possible values are:

* ``installer``, in the OS installer system before the first boot (debian-installer or anaconda)
* ``ondisk``, the system has been installed on disk and is running
* ``diskless-preinit``, first run on a diskless system before downloading the system image
* ``diskless-postinit``, the system has been booted from a diskless image and is running

#### Fact: ``netconfig`` (network)

Hash defining for each interface the IP address to configure.

Same on all nodes.

Example:

```
    netconfig: 
      eth0: 
        - "10.100.4.1/255.255.248.0"
      bond1: 
        - "192.168.42.47/255.255.255.0"
        - "192.168.42.57/255.255.255.0"
```

#### Fact: ``dhcpconfig`` (network)

Hash defining for each node in the HPC cluster a pair macaddress/ipaddress.

Same on all nodes.

Example:

```
    dhcpconfig: 
      genadmin1: 
        macaddress: "52:54:00:c1:c4:9c"
        ipaddress: "10.100.0.1"
      gencritical1: 
        macaddress: "52:54:00:65:e5:74"
        ipaddress: "10.100.2.11"
      gencritical2: 
        macaddress: "52:54:00:48:63:38"
        ipaddress: "10.100.2.12"
```

#### Fact: `hostfile` (network)

For each node give the hostname/ip address association. 

Same on all nodes.

Example:

```
    hostfile: 
      genadmin1: "10.100.0.1"
      extgenadmin1: "192.168.42.41"
      gencritical1: "10.100.2.11"
      gencritical: "10.100.2.10"
      extgencritical1: "192.168.42.43"
      extgencritical: "192.168.42.53"
      gencritical2: "10.100.2.12"
      extgencritical2: "192.168.42.44"
```

#### Fact: `ifaces_target` (network)

#### Fact: `mymasternet` (network)

Broken down master_network line for the current node.

Example:

```
    mymasternet: 
      - "52:54:00:07:5b:ac,52:54:00:d8:97:45,52:54:00:88:aa:38,52:54:00:8a:07:d3"
      - "bond0,bond1,eth0,eth1,eth2,eth3"
      - "genmisc1,genmisc,extgenmisc1,extgenmisc"
      - "10.100.2.21,10.100.2.20,192.168.42.45,192.168.42.55"
      - "255.255.248.0,255.255.255.0"
      - "0@0@0"
      - "0@0@0,0@1@0,1@2@1,1@3@1"
      - "0@0,1@1,2@2,3@3"
```

#### Fact: `mynet_topology` (network)

Network topology from the perspective of the current node, gives where each network is connected on the current node (``interfaces``) and the name of the network.

Example:

```
    mynet_topology: 
      administration:
        interfaces: 
          - eth0
        name: CLUSTER
        firewall_zone: clstr
        external_config: false
      wan: 
        interfaces: 
          - bond1
        name: EXT
        firewall_zone: wan
        external_config: false

```

#### Fact: `myprofiles` (profiles)

Array of active profiles on the current node.

#### Fact: `profiles` (profiles)

Hash with roles as keys and array of active profiles for this node type as value.

#### Fact: `my_XXXXX_{server,relay,mirror,replica,tracker,proxy}` (profiles)

Those facts give for each profile ``profiles::XXXXXX::{server,relay,mirror,replica,tracker,proxy}`` which role has the profile defined. This value can then be used elsewhere in the configuration to configure the clients.

Example:

```
    my_conman_server: misc
    my_ntp_server: critical
    my_dns_server: critical
    my_postfix_relay: misc
```

#### Fact: `puppet_role` (roles)

Roles are derived from the name of the node: ``<cluster_prefix><role><numerical_id>``. The ``cluster_prefix`` is read from hiera. If nothing matches, the role is ``default``. 

#### Fact: `hostsby_role` (roles)

Hash giving a list of hostnames by role, the source is the ``hostfile`` fact (see above). All host names matching the rule of ``puppet_role`` will be included, ``default`` role is not included.

```~
    hosts_by_role: 
      admin: 
        - genadmin1
      critical: 
        - gencritical1
        - gencritical2
      misc: 
        - genmisc1
        - genmisc2
      batch: 
        - genbatch1
        - genbatch2
      front: 
        - genfront1
      cn: 
        - gencn01
```

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
