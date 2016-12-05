# pam

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What pam affects](#what-clara-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pam](#beginning-with-clara)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure PAM modules

## Module Description

This module provides a base pam configuration and subclasses to configure
some specific PAM modules. Supported modules are:

* `access`, authentication access list
* `limits`, set resource limits for the processes of the session
* `pwquality`, check password quality when user changes passwords
* `slurm`, only authorizes users with a SLURM job on the node
* `sss`, authentication uses the sssd daemon

## Setup

### What pam affects

Users authorized to use the system and user sessions.

### Setup Requirements

This module depends on:

* `hpclib`

### Beginning with pam


## Usage

Include the class corressponding to the modules you wish to activate on the
nodes.

## Limitations

Some modules do not supports Redhat:

* `sss`
* `slurm`
* `pwquality`
* `limits`

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
