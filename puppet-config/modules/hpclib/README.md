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

* Define facts and functions

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
* Rsync in a crontab

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

**DEPRECATED**

#### Fact: `mymasternet` (network)

``master_network`` info for the current node.

Example:

```
    mymasternet: 
      fqdn: cladmin1.cluster.hpc.example.com
      networks: 
        administration: 
          DHCP_MAC: "0d:bf:3d:a9:aa:02"
          IP: "10.1.1.11"
          device: bond1
          hostname: cladmin1
        lowlatency: 
          IP: "10.1.2.11"
          device: ib0
          hostname: ibcladmin1
        bmc: 
          DHCP_MAC: "0d:bf:3d:a9:aa:05"
          IP: "172.16.1.32"
          hostname: wanbmccladmin1
        management: 
          IP: "10.1.0.211"
          device: bond1
          hostname: mgtcladmin1
        wan: 
          IP: "172.16.1.1"
          device: bond2
          hostname: wancladmin1
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

#### Fact: `puppet_index` (roles)

Index are derived from the name of the node: ``<cluster_prefix><role><numerical_id>``. The ``cluster_prefix`` is read from hiera. If nothing matches, the index is ``default``. 


#### Fact: `hosts_by_role` (roles)

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

### Functions

Function are described more completely in the code comments.

#### Function: `decrypt($target, $passwd)`

Decrypts the file `$target` with key: `$passwd`.

#### Function: `hpc_atoh($array)`

Returns a hash with array values as keys.

#### Function: `hpc_dns_zones()`

Returns a hash describing `::dns::server::zones` resources for the current cluster.

#### Function: `hpc_get_hosts_by_profile($profile)`

Returns an array with the hosts that have the profile given in
parameter.

``profile`` name should not contain the ``profiles::`` prefix.

#### Function: `hpc_ha_vip_notify_scripts()`

Returns a hash describing `::hpc_ha::vip_notify_script` resources for the current host.
List comes from hiera.

#### Function: `hpc_ha_vips()`

Returns a hash describing `::hpc_ha::vip` resources for the current host. List
comes from hiera.

#### Function: `hpc_ha_vservs()`

Returns a hash describing `::hpc_ha::vserv` resources for the current host. List
comes from hiera.

#### Function: `hpc_hmap($hash, $key)`

Transforms a hash of value into a hash of hash. 

```
hpc_hmap({ 'a' => '0' }, 'K')
```
returns:

```
{"a"=>{"K"=>"0"}}
```

#### Function: `hpc_nodeset_expand($nodeset)`

Transforms a ClusterShell nodeset into an array of hostnames.

#### Function: `hpc_nodeset_fold($array)`

Transforms an array of hostnames into a ClusterShell nodeset.

#### Function: `hpc_roles_nodeset($roles)`

Returns a hash where the keys are the roles passed as parameters and the
values are the ClusterShell nodeset of all the machines having that role
in the configuration.

#### Function: `hpc_roles_single_nodeset($roles)`

Returns a ClusterShell nodeset of all the machines having one of the roles
given in the array in parameter.

#### Function: `hpc_shorewall_interfaces()`

Reads the `firewall_zone` parameter in the network topology definition and
returns a hash of describing `::shorewall::interface` for the current host.

#### Function: `hpc_source_file($source)`

Returns the content of a file read from the source. The source can be:

- An absolute file path
- A relative file path refers to a module `files` directory (`<module>/<file_path>`)
- An URL (`file://` or `http://`)

If `$source` is an array, all sources are tried successively.

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
