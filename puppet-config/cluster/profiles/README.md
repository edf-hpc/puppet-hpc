# profiles

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What profiles affects](#what-profiles-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with profiles](#beginning-with-profiles)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Classes to define profiles that should be affected to roles.

## Module Description

This modules define profiles for setting up features on a role. Profiles get
the parameters in hiera.

Profiles are grouped by sections:

* *apt*, APT proxy
* *access*, access list to a host
* *auth*, authentication on the host
* *backup*, backup some service/equipment configuration or state
* *bootsystem*, install/diskless boot server
* *ceph*, Ceph storage system
* *clara*, cluster administration tool
* *clearsel*, Clean IPMI logs
* *clush*, clustershell parallel shell
* *cluster*, basic configuration for an HPC cluster node
* *conman*, conman serial console server
* *db*, SQL database (MariaDB/Galera)
* *dhcp*, DHCP service
* *dns*, DNS client and server
* *environment*, environment for users
* *filesystem*, create directories, symlinks, mounts...
* *firewall*, firewall (Shorewall)
* *flexlm*, FlexLM license manager service
* *ftp*, FTP service (ProFTPd)
* *gpfs*, IBM GPFS (Spectrum Scaler) service
* *ha*, High Availability tools
* *hardware*, Hardware tools and tuning
* *hpcconfig*, puppet-hpc tools configuration
* *hpcstats*, HPCStats
* *http*, Web server (Apache)
* *infiniband*, Infiniband drivers and userspace (OFED)
* *inventory*, hardware and system inventory (Fusion-Inventory and GLPI)
* *jobsched*, Job scheduler (SLURM)
* *log*, System log management
* *metrics*, Metrics collection and management
* *monitoring*, Monitoring agents and plugins (Icinga2)
* *neos*, NEOS remote graphics tool
* *network*, Host network configuration
* *nfs*, NFS service
* *ntp*, NTP service
* *opa*, Intel Omni-Path low latency network drivers and userspace
* *openssh*, SSH configuration and keys
* *p2p*, Peer to Peer system (bittorrent) service
* *pam*, Linux Authentication (Plugabble Authentication Modules)
* *postfix*, Full featured MTA
* *software*, Application software
* *ssmtp*, Basic MTA
* *sudo*, sudo permissions
* *virt*, Virtualization host with libvirt/kvm
* *xorg*, X.org graphical server (including nvidia drivers)

## Setup

### What profiles affects


### Setup Requirements

This module requires pluginsync to make facts work in an agent/master
configuration. 

The profiles defined in this module require the puppet-hpc modules.

### Beginning with profiles

profiles facts relies on a cluster definition in hiera:
https://edf-hpc.github.io/puppet-hpc/PuppetHPCConfiguration.html#_cluster_definition

## Usage

Classes (profiles) defined by this module should be included by *roles*
definitions. In *Puppet HPC*, the roles are defined in hiera (key: `profiles`).

## Limitations

This module is mainly tested on Debian. Some profiles are also tested on RedHat (RHEL,
CentOS).

List of profiles that are tested on RedHat:

- ``profiles::access::base``
- ``profiles::cluster::common``
- ``profiles::dns::client``
- ``profiles::environment::limits``
- ``profiles::hardware::ipmi``
- ``profiles::hpcconfig::apply``
- ``profiles::log::client``
- ``profiles::network::base``
- ``profiles::ntp::client``
- ``profiles::openssh::server``

Some of these profiles might have further limitationson RedHat. See the relevant generic
modules documentation.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
