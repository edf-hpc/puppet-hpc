# nfs

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What nfs affects](#what-nfs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nfs](#beginning-with-nfs)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure NFS client or server, manages mount and exports.

## Module Description

The modules define a class for the server and one for the client. The module
defines resources type that can be used to mount NFS exports on the client and
to define new exports on the server.

## Setup

### What nfs affects

### Setup Requirements

This module uses the concat Puppet modules.

### Beginning with nfs

## Usage

On the server:

* Include the class `::nfs::server`
* Define exports with the resource `::nfs::server::export`

On the client:

* Include the class `::nfs::client`
* Define exports with the resource `::nfs::client::mount`

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
