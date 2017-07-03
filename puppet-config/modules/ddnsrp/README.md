# ddnsrp

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What ddnsrp affects](#what-ddnsrp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ddnsrp](#beginning-with-ddnsrp)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

The module deploys ddnsrp deploys Infiniband SRP components provided by DDN.

## Setup

### What ddnsrp affects

The module installs DDN specific Infiniband SRP software components and setup
the related kernel module.

### Setup Requirements

N/A

### Beginning with ddnsrp

N/A

## Usage

The ddnsrp module has only one public class named `ddnsrp`. It can be easily
instanciated with its defaults argument:

```
include ::ddnsrp
```

Using Infiniband SRP usually requires and OpenSM instance to manage the link
between the node and the SRP SAN. For this purpose, you might probably want to
use the current module in conjuction with the `opensm` module.

## Limitations

This module has only been tested on RHEL.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
