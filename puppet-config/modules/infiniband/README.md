# infiniband

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What infiniband affects](#what-infiniband-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with infiniband](#beginning-with-infiniband)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description

The module deploys the Mellanox OFED Linux software stack on nodes.

## Setup

### What infiniband affects

* Mellanox OFED Linux node packages
* OpenIB service configuration file 

### Setup Requirements

This module depends in:

* `stdlib` module (`validate_*()` and `merge()` functions)
* `hpclib` module (`print_config()` function)

### Beginning with infiniband

N/A

## Usage

The `infiniband` module has one public class `infiniband`. Here is an example of
this public class instanciation:

```
include ::infiniband
```

It is possible to control whether the `mlx4` module is loaded or not with the
`mlx4load` parameter:


```
class { '::infiniband':
  mlx4load => 'yes',
}
```

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
