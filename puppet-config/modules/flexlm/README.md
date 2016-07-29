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

* The flexlm unit file for the specific vendor used by systemd
* The user running the flexlm service
* The log file of the flexlm service 

### Setup Requirements

This module uses the module hpclib from edf-hpc.

### Beginning with flexlm


## Usage

* Include the class `flexlm::params`
* Define a flexlm server for a vendor with the resource `flexlm::service`

```
  include flexlm::params
  flexlm::service { 'intel':
    binary_path     => $intel_binary_path,
    license_path    => $intel_license_path,
    vendor_name     => 'intel',
    user_home       => $intel_user_home,
    systemd_config  => $intel_systemd_config,
    systemd_service => $intel_systemd_service,
  }
```

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
