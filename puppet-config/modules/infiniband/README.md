# infiniband

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What infiniband affects](#what-infiniband-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with infiniband](#beginning-with-infiniband)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

The module deploys the Infiniband OFED Linux software stack on nodes.

It can deploy two types of stacks:

* the ``mlnx`` stack is the stack from Mellanox. It works on Debian and
  RedHat.
* the ``native`` stack is packaged by the distribution. Only supported on
  RedHat.

## Setup

### What infiniband affects

* OFED Linux node packages
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

The stack is selected by using the parameter ``ofed_version``, that have the values
``mlnx`` for the Mellanox stack and ``native`` for the stack packaged by the
distribution. By default, the ``mlnx`` stack is selected since it is usually the one
providing the best performance.

```
class { '::infiniband':
  ofed_version => 'native',
}
```

Changing the stack can also change the name of the service or the name of the configuration
files.

## Limitations

No ``native`` stack on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
