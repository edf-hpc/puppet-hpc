# environment_modules

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What environment_modules affects](#what-environment_modules-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with environment_modules](#beginning-with-environment_modules)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Configure user environment_modules. This provides the "modules" shell function to
setup environment variables.

## Module Description

The "modules" command is used to load and unload environment variables from 
user tools. This permit installing multiple implementation of the same tool
and let the user select which one to use. This puppet module sets-up the
command on the local node.

## Setup

### What environment_modules affects

Install the environment_modules package and configure it.

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with environment_modules

## Usage

Include the class:

```
class{ '::environment_modules':
  config_options => [
    '/share/modulefiles/compiler',
    '/share/modulefiles/mpi',
  ],
  rootdirmodules => 'rootdirmodules',
}
```  

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
