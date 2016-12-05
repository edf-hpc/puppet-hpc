# openssh

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What openssh affects](#what-clara-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with openssh](#beginning-with-clara)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure openssh client and server

## Module Description

This module installs and configures OpenSSH clients and servers as is
frequently seen in HPC cluster. It authorize a root key on every node and
permits to have stable and deterministic hosts keys accross nodes reinstall.

## Setup

### What openssh affects

The `openssh::server` class **will authorize a specific key to connect as
root**, you must provide your own key to avoid using a default key that is
[published on the Internet](https://github.com/edf-hpc/puppet-hpc/tree/master/puppet-config/modules/openssh/files).

The `openssh::client` will (by default) deactivate the `StrictHostKeyChecking` 
setting. This means that the client will automatically trust new hosts without
a prompt.

### Setup Requirements

The module uses the following modules:

* edfhpc-hpclib

### Beginning with openssh

Generate keys for your local site:

* RSA root keys
* Hosts keys

Private keys should be encrypted with OpenSSL (see encryption in hpclib mdoule).

Make the keys available to the nodes (puppet, HTTP, local file...), and set
the source values for the keys: 

* `::openssh::server::root_public_key`
* `::openssh::server::hostkeys_source_dir`
* `::openssh::client::root_key_enc`

After applying the server class, if you already connected to the server, you
might have to remove the entries in your `~/.ssh/known_hosts` file.


## Usage

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
