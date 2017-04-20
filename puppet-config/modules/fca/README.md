# fca

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What fca affects](#what-fca-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with fca](#beginning-with-fca)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

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

The `fca` module has two public class `fca` and `fca::server`. Here is an example of
the public class instanciation `fca` :

```
include ::fca
```

The `fca` class installs the package and `fca::server` sets up the server. `fca` is
automatically installed by `fca::server`.

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
