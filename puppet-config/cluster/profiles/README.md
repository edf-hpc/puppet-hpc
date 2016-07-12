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

* *access*, access list to a host
* *auth*, authentication on the host
* *bootsystem*, install/diskless boot server
* *clara*, cluster administration tool
* *clush*, clustershell parallel shell
* *cluster*, basic configuration for an HPC cluster node
* *conman*, conman serial console server
* *db*, SQL database (MariaDB/Galera)
* *dhcp*, DHCP service
* *dns*, DNS client and server
* *environment*, environment for users
* *firewall*, firewall (Shorewall)
* *ftp*, FTP service (ProFTPd)
* *gpfs*, IBM GPFS (Spectrum Scaler) service
* *ha*, High Availability tools
* *hardware*, Hardware tools and tuning
* *http*, Web server (Apache)
* *jobsched*, Job scheduler (SLURM)
* *log*, System log management
* *metrics*, Metrics collection and management
* *neos*, NEOS remote graphics tool
* *network*, Host network configuration
* *nfs*, NFS service
* *ntp*, NTP service
* *openssh*, SSH configuration and keys
* *p2p*, Peer to Peer system (bittorrent) service
* *postfix*, Full featured MTA
* *software*, Application software
* *ssmtp*, Basic MTA
* *sudo*, sudo permissions
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

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
