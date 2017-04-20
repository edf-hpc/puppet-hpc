# fca

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What fca affects](#what-fca-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with fca](#beginning-with-fca)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description

The module deploys the fca libraries.

## Setup

### What fca affects

* fca soft packages and service

### Setup Requirements

This module depends in:

* `stdlib` module (`validate_*()` functions)

### Beginning with fca

N/A

## Usage

The `fca` module has two public class `fca::client` and `fca::server`. Here is an example of
the public class instanciation `fca::client` :

```
include ::fca::client
```

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
