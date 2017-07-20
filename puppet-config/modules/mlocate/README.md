# mlocate

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What mlocate affects](#what-mlocate-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mlocate](#beginning-with-mlocate)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure mlocate. mlocate is tool to search files quickly on the
local filesystem. It relies on a database updated every night.

## Module Description

This module install mlocate and generate a usable configuration.

## Setup

### What mlocate affects

Install mlocate and generate a usable configuration

### Setup Requirements

This module uses the module hpclib from edf-hpc.

### Beginning with mlocate

The mlocate module sets the default configuration with the gpfs
filesystem included in the list of pruned FS.

Other paths and fs can be added as a parameter.

## Usage

Include the class:
```
  class { '::mlocate':
    extra_prunepaths => '/scratch'
  }
```

## Limitations

This module is tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
