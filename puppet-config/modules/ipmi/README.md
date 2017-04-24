# ipmi

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What ipmi affects](#what-ipmi-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ipmi](#beginning-with-ipmi)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Loads IPMI kernel modules.

## Module Description

This modules configures the OS to load IPMI kernel modules during the boot
sequence.

On Debian, by default the modules removes ipmi_poweroff from the list of
the loaded modules. It does not always work on some hardware (notably:
IBM X3550M4).

## Setup

### What ipmi affects

Modules loaded during boot.

### Setup Requirements

None

### Beginning with ipmi

## Usage

```
include ::ipmi
```

The list of modules is provided with the `config_options` array.


## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
