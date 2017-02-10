# pstate

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What pstate affects](#what-pstate-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pstate](#beginning-with-pstate)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Add a service that configures Intel pstates

On modern Intel Xeon processor, frequency is controlled by a feature called the
pstate. This module sets up a script that will be run during a host startup to
set the processor to its maximum frequency.

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with pstate

Just include the main class:

```
include ::pstate
```

##Usage

The content of the script cannot be modified, but it can be replaced with
another script with the ``script_file`` parameter.

Other parameters can be used to change the content of the Systemd unit file.

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
