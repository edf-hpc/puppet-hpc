# FusionInventory

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What FusionInventory affects](#what-fusioninventory-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with FusionInventory](#beginning-with-fusioninventory)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure the FusionInventory agent. FusionInventory acts like a gateway and collect information sent by the agents. It creates or updates the information in GLPI.

## Module Description

This module installs the FusionInventory agent and generates its configuration.

## Setup

### What FusionInventory affects

Install and configure the FusionInventory agent.

### Setup Requirements

This module uses the module hpclib from edf-hpc.

### Beginning with FusionInventory

N/A

## Usage

The fusioninventory module has only one public class named `fusioninventory`. 
It can be easily instanciated with its defaults argument:

```
include ::fusioninventory
```

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
