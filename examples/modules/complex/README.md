# complex

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What iscdhcp affects](#what-iscdhcp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with iscdhcp](#beginning-with-iscdhcp)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description

The module deploys complex client and server.

## Setup

### What complex affects

The module installs complex software in both client and server modes. It manages
the configuration files and services.

### Setup Requirements

The module depends on:

* `stdlib` module (for `deep_merge()` function),
* `hpclib` module (for `print_config()` function).

### Beginning with complex

N/A

## Usage

The complex module has two public classes:

* `complex::client`
* `complex::server`

As their name suggest, they respectively manage the client and server parts of
complex software.

The client public class expects a password:

```
class { '::complex::client':
  password       => 'CHANGEME',
}
```

The server public class mainly expects a partial configuration options hashes
and a password:

```
class { '::complex::server':
  config_options => {
    'section1' => {
      'param1' => 'value7',
      'param2' => 'value8',
    },
    'section3' => {
      'param5' => 'value5',
      'param6' => 'value6',
    },
  },
  password       => 'CHANGEME',
}
```

The `config_options` hash is deep-merged (using `stdlib` `deep_merge()`
function) with the default hash from manifest `server::params.pp`. Ideally, the
hash given in argument should only contain the difference with the default hash.
The default hash value is:

```
  $config_options  = {
    'section1' => {
      'param1' => 'value1',
      'param2' => 'value2',
    },
    'section2' => {
      'param3' => 'value3',
      'param4' => 'value4',
    },
  }
```

After the deep merge, the resulting hash is:

```
  $config_options  = {
    'section1' => {
      'param1' => 'value7',
      'param2' => 'value8',
    },
    'section2' => {
      'param3' => 'value3',
      'param4' => 'value4',
    },
    'section3' => {
      'param5' => 'value5',
      'param6' => 'value6',
    },
  }
```

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
