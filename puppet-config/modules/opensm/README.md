# opensm

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What opensm affects](#what-opensm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with opensm](#beginning-with-opensm)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description

The module deploys the OFED OpenSM Infiniband Subnet manager.

## Setup

### What opensm affects

* OpenSM soft packages and service

### Setup Requirements

This module depends in:

* `stdlib` module (`validate_*()` functions)

### Beginning with opensm

N/A

## Usage

The `opensm` module has one public class `opensm`. Here is an example of
this public class instanciation:

```
include ::opensm
```

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
