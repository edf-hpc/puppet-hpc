# GLPI Collector

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What GLPI Collector affects](#what-glpicollector-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with GLPI Collector](#beginning-with-glpicollector)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure the system that collects information for GLPI from the FusionInventory agents.

## Module Description

This module installs a PHP script that collects information from the FusionInventory agents and a BASH script that injects the inventory files to the GLPI server. It configures the crontab to execute the injection script.

## Setup

### What GLPI Collector affects

Install 2 scripts and modify the root crontab.

### Setup Requirements

This module uses the module hpclib from edf-hpc.

### Beginning with GLPI Collector

N/A

## Usage

The glpicollector module has only one public class named `glpicollector`. 
It can be easily instanciated with its defaults argument:

```
include ::glpicollector
```

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
