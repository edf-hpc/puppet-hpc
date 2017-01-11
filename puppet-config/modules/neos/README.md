# neos

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What neos affects](#what-neos-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with neos](#beginning-with-neos)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)


## Module Description

Install and configure neos. A tool to launch graphical environment in a slurm
job.

The module installs the neos package on the execution and submit nodes. It can
also generate a Paraview server file (`.pvsc`).

## Setup

### Setup Requirements

Module dependency:

 * ``hpclib``
 * ``apache`` (for ``neos::web``)

### Beginning with neos


## Usage


### neos
Include the neos class on graphical nodes and submit hosts.

The default configuration might be correct for your site, but you should at
least provide a cluster name:

```
class { '::neos':
  config_options => {
    'cluster' => {
      'name' => 'clustername'
    }
  },
}
```


### neos::web

The class `::neos::web` should be installed on a web server. This class will
setup an alias to a file ``server.pvsc`` that will be exported.

The content of the file is:

 * Generated from the neos configuration ``neos_options`` parameter
 * A source for the file
 * The content directly

```
class { '::neos::web':
  neos_options => {
    'cluster' => {
      'name' => 'clustername'
    }
  },
}

```

## Limitations

This module only supports Debian (no RedHat packaging for neos). 

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
