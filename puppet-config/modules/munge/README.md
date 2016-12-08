# munge

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What dns affects](#what-munge-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with dns](#beginning-with-munge)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and setup munge with encrypted key.

## Module Description

This module can install and configure munge. This module manage munge encrypted key. 
This module is associated to slurm (managed by jobsched module).

## Setup

### What munge affects

It install packages, deploy key file and manage service munge.

### Setup Requirements

This module uses hpclib.

### Beginning with munge

## Usage

To have Puppet install Munge with the default parameters, declare the munge class:

```
class { 'munge': }
```

## Configuring on Slurm Server

```
include ::munge
Class['::munge::service'] -> Class['::slurm::dbd::service'] -> Class['::slurm::ctld::service']
```

## Configuring on Slurm Client

```
include ::munge
```

## Configuring on Slurm nodes (slurmd)

```
include ::munge
Class['::munge::service'] -> Class['::slurm::exec::service'
```

## Limitations

This module is tested on Debian and RHEL.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
