# aufs

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

The module configures an additional branch in `aufs`. It is mainly used
on nodes deployed in RAM using the Debian live system (which uses `aufs`).

## Setup

This module depends on the loaded `aufs` kernel module.

## Usage

The branch to load must be specified in hiera in `profiles::environment::userspace::aufs_branch`.

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
