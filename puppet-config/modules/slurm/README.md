# slurm

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What slurm affects](#what-slurm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with slurm](#beginning-with-slurm)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure Slurm. A job scheduler and resource manager for HPC.

## Module Description

This module installs [Slurm](http://slurm.schedmd.com/) and generates an usable
configuration. The module is tested to work with the Debian packages published
by the EDF-HPC team. The sources with the Debian packaging files can be found at:

* [Slurm itself](https://github.com/edf-hpc/slurm-llnl)
* [Some helper plugins and
  scripts](https://github.com/edf-hpc/slurm-llnl-misc-plugins)

This module sets up all the components of Slurm in different classes:

* `ctld`, for the controller daemon (`slurmctld`)
* `exec`, for the node execution daemon (`slurmd`)
* `client`, for the client commands and tools
* `dbd`, for the accounting service (`slurmdbd`)

## Setup

### What slurm affects

### Setup Requirements

This module needs a working authentication mechanism in the cluster. This
system is usually `munge`. It should be setup on every node.

The `dbd` class needs access to a MySQL database.

This module depends on:

* `puppetlabs-stdlib`
* `edfhpc-hpclib`

### Beginning with slurm

You should setup the different components of Slurm, nodes generally include one
or more features:

* **Batch node**, include: `client`, `ctld` and `dbd`
* **Execution node**, include: `client` and `exec`
* **Submission host**, include: `client`
* **Administration node**, include: `client`

The difference to keep in mind between a submission host and an administration
node is that the submission host must have `srun` prologs. Features can be
confused on smaller configurations.

It's possible to separate `dbd` and `ctld`.

The main module class (`slurm`) does not install anything but handles the
configuration file that is common to all other classes (`slurm.conf`).

## Usage

### Configuration

The configuration is built by setting values in the `$config_options`
parameter. The values are merged with the default configuration.

The parameter `$partitions_options` can be used to define the nodes and
partition.

A minimum configuration would look like this:

```
class { '::slurm':
  config_options     => {
    'ClusterName' => {
      value   => 'hpccluster',
      comment => 'The name by which this SLURM managed cluster is known in the accounting database',
    },
    'ControlMachine' => {
      value   => 'master',
      comment => 'Hostname of the machine where SLURM control functions are executed',
    }
  },
  partitions_options => [
    "NodeName=node[001-010] CPUs=1 State=UNKNOWN",
    "PartitionName=std Nodes=node[001-010] Default=YES MaxTime=INFINITE State=UP",
  ],
}
```

See the `hpclib::print_config`` documentation for the `$config_options` hash syntax.

Every entry in `slurm.conf` can be defined, it is also possible to add `Include` entries.

### Cgroups

Cgroups are configured in a separate file, only used by the `exec` class. This
class provides the parameters to configure the cgroups in Slurm. The main
parameters are: `$enable_cgroup` and `cgroup_options`.


## Limitations

This module is mainly tested on Debian, but it is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
