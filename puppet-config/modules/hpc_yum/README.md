# hpc_yum

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What hpc_yum affects](#what-hpc_yum-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hpc_yum](#beginning-with-hpc_yum)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Wrapper module to use the Puppetlabs yumrepo resource in a different stage

This module uses the yumrepo resource to manage YUM repositories.

## Setup

### What hpc_yum affects

This module configures yum.

### Setup Requirements

Default Puppet.

### Beginning with hpc_yum

N/A

## Usage

The hpc_yum module has only one public class named `hpc_yum`. It can be easily
instanciated with its defaults argument:

```
include ::hpc_yum
```

## Limitations

Tested on EL6

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
