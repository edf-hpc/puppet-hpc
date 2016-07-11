# warewulf_nhc

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with warewulf_nhc](#beginning-with-warewulf_nhc)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure warewulf-nhc. A node health checker for schedulers like Slurm.
https://github.com/mej/nhc

## Module Description

This module install warewulf-nhc and generate a usable configuration. 

## Setup

This module does not provide a default configuration, as it depends of the
cluster configuration.

### Setup Requirements

This module require the edf-hpc/hpclib module.

### Beginning with warewuf_nhc

You must pass the content of the configuration file in a hash formated like
this :
```
$config_options = {
  'name_of_the_check' => {
    comment    => 'Comments associated to this check',
    nodes      => 'nodes_concerned',
    command    => 'command_to_execute',
  },
```
For example, this hash :
```
$config_options = {
  'rm' => {
    comment    => 'Explicitly instruct NHC to assume the Resource Manager',
    nodes      => '*',
    command    => 'export NHC_RM=slurm',
  },
```
will generate this config file :
```
### Explicitly instruct NHC to assume the Resource Manager ###
* || export NHC_RM=slurm
```
## Usage

Include the warewulf_nhc class.

## Limitations

This module is only tested on Debian.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
