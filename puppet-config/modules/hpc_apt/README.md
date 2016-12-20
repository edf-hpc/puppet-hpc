# hpc_apt

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What hpc_apt affects](#what-hpc_apt-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hpc_apt](#beginning-with-hpc_apt)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Wrapper module to use the Puppetlabs apt module in a different stage

## Module Description

This module uses the apt module to manage Apt (Advanced Package Tool) sources,
keys and other configuration options.

## Setup

### What hpc_apt affects

This module includes the apt module and uses its conf and source ressources.

### Setup Requirements

This module relies on the Puppetlabs apt module.

### Beginning with hpc_apt

N/A

## Usage

The hpc_apt module has only one public class named `hpc_apt`. It can be easily
instanciated with its defaults argument:

```
include ::hpc_apt
```

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
