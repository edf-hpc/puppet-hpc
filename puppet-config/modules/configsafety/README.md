# Config Safety

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What configsafety affects](#what-configsafety-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with configsafety](#beginning-with-configsafety)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Configures ConfigSafety

Config Safety are a solution for backup directories ti anohter destination with dar or rsync

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with configsafety

## Usage

```
profiles::backup::configsafety::node_cfg: 'servername'

configsafety::config_options:
    'bck_name': 'configsafet'
    # Dar 
    'path_bck_dar_dir': '/home'
....

configsafety::config_path_incl_dar:
    - 'save.core'
    - 'test'
....
```

## Limitations

This module is mainly tested on Debian, configsafety is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
