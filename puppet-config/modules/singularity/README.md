# singularity

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What singularity affects](#what-singularity-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with singularity](#beginning-with-singularity)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Overview


## Module Description

Install and configure singularity. singularity is a tool to run containers
specifically designed for HPC environments.

This module install singularity and generate a usable configuration.

## Setup

### What singularity affects

Install singularity and generate a usable configuration. It also override the
default environment init file (`/etc/singularity/init`).

### Setup Requirements

This module uses the module hpclib from edf-hpc.

### Beginning with singularity

## Usage

Include the class:
```
  class { '::singularity': }
```

To use another init file:
```
  class { '::singularity':
    envinit_manage => true,
    envinit_source => 'http://files.hpc.example.com/singularity/init',
  }
```

## Limitations

This module is tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
