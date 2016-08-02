# neos

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What neos affects](#what-neos-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with neos](#beginning-with-neos)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure neos. A tool to launch graphical environment in a slurm
job.

## Module Description

The module installs the neos package on the execution and submit nodes. It can
also generate a Paraview server file (`.pvsc`).

## Setup

### What neos affects

### Setup Requirements

Module dependency:
 * `hpclib`

### Beginning with neos

The default configuration might be correct for your site, but you should at
least provide a cluster name:

```
class { '::neos':
  config_options => {
    'cluster' => {
      'name' => 'clustername'
    }
  },
}
```

## Usage

Include the neos class on graphical nodes and submit hosts.

The class `::neos::web` should be installed on a web server.

## Limitations

This module only supports Debian (no RedHat packaging for neos). 

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
