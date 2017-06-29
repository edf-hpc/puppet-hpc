# gpfs

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What gpfs affects](#what-gpfs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with GPFS](#beginning-with-gpfs)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

GPFS (or Spectrum Scale) is a high-performance clustered file system. 

## Module Description

This module deploys the software component required on GPFS nodes.

## Setup

### What gpfs affects

The module installs the GPFS software in both client and server modes.

### Setup Requirements

The module depends on:

* `hpclib` module (for `print_config()` function).

### Beginning with complex

N/A

## Usage

The gpfs module has one public classes:

* `gpfs`

The public class expects at least a public key and optionnally a few other arguments:

```
class { '::gpfs':
  public_key               => 'ENCRYPTION_KEY',
  cluster                  => 'cluster_name',
  cl_decrypt_passwd        => 'CHANGEME',
  cl_key_src               => 'gpfs/genkeyData1.enc',
  cl_config_src            => 'gpfs/mmsdrfs.enc',
  cl_perf_src              => 'gpfs/perf.enc',
  service_override_options => {
    'Service' => {
      'ExecStartPre' => '/bin/true',
      'Restart'      => 'on-failure',
      'RestartSec'   => '5',
    },
  }
}
```

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
