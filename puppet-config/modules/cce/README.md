# cce

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What cce affects](#what-cce-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with cce](#beginning-with-cce)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Configures CCE commands

CCE commands are a set of tools to display info like queue state or quota. This
module is used to create the configuration file and install the package.

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with cce

## Usage

```
class { '::cce':
  config_options => {
    'enable_cce_quota' => 'on',
    'listofvolume'     => "cluster.gpfs:/dev/gpfscluster:home|gpfs|filesetuquota|home
cluster.gpfs:/dev/gpfscluster:scratch|gpfs|filesetuquota|scratch",
  }
}
```

## Limitations

This module is mainly tested on Debian, cce is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
