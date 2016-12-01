# hpc_user

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What hpc_user affects](#what-hpc_user-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hpc_user](#beginning-with-hpc_user)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Configure users

## Module Description

This module configures system users (only root for now).

## Setup

### What hpc_user affects

Define the `User['root']` resource. The `hpc_user::root` wrapper class enables
putting it inside a stage.

### Setup Requirements

Nothing.

### Beginning with hpc_user

## Usage

```
  class{ '::hpc_user::root':
    password => <somepasswordhash>,
    stage    => 'first',
  }
```

The point of this class is to permit to set the root user definition in the
earliest stage.

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
