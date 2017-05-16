# singularity

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What singularity affects](#what-singularity-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with singularity](#beginning-with-singularity)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure singularity. singularity is a tool to run containers specifically designed for HPC environments.

## Module Description

This module install singularity and generate a usable configuration.

## Setup

### What singularity affects

Install singularity and generate a usable configuration

### Setup Requirements

This module uses the module hpclib from edf-hpc.

### Beginning with singularity

## Usage

Include the class:
```
  class { '::singularity': }
```

## Limitations

This module is tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
