# Hpc-config 

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What hpcconfig affects](#what-hpcconfig-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hpcconfig](#beginning-with-hpcconfig)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description

Configures hpc-config commands

hpc-config-apply downloads and apply a puppet-hpc configuration.
hpc-config-push push puppet-hpc configuration into central storage.

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with hpcconfig

## Usage

Include the hpcconfig::push and hpcconfig::apply classes on required nodes.
Usually hpcconfig::push is used on admin node(s), and hpcconfig::apply on all 
nodes.

'hpcconfig::apply::config_options' and 'hpcconfig::push::config_options' must
be provided to have a fully-functionnal configuration.

## Limitations

This module is mainly tested on Debian, hpcconfig is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
