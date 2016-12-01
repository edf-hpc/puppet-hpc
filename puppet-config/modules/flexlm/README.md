# flexlm

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What flexlm affects](#what-flexlm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with flexlm](#beginning-with-flexlm)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Set up a FLEXLM server for a specific vendor

## Module Description

This module defines a type of resource called flexlm::service and that can be used to set up a flexlm server for a specific vendor.

## Setup

### What flexlm affects

Installs a flexlm server and sets up a license file.

### Setup Requirements

This module uses the module hpclib from edf-hpc.

### Beginning with flexlm


## Usage

Include the class:
```
  class{ '::flexlm':
    license_path     => '/opt/intel/server.lic',
    license_path_src => 'http://server/intel/server.lic.enc',
    decrypt_password => 'passw0rd' 
  }
```

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
