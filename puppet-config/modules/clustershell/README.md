# clustershell

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What clustershell affects](#what-clustershell-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with clustershell](#beginning-with-clustershell)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure clustershell. Clustershell is a tool designed to run commands in parallel on Linux cluster.

## Module Description

This module install clustershell and generate a usable configuration.

## Setup

### What clustershell affects

Install clustershell and generate a usable configuration

### Setup Requirements

This module uses the module hpclib from edf-hpc.

### Beginning with clustershell

## Usage

Include the class:
```
  class { '::clustershell':
    groups => $groups,
    groups_options => {
      'Main' => {
        'default' => $default_source,
      },
    }
  }
```

## Limitations

This module is tested on Debian and RHEL.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
