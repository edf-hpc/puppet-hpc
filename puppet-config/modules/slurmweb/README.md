# slurmweb 

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What clara affects](#what-clara-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with clara](#beginning-with-clara)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure slurmweb REST API.

## Module Description

This module install slurmweb REST API and configure a vhost in 
apache web server configuration.

## Setup

### What slurmweb affects

### Setup Requirements

This module provides a default configuration, but it must be replaced by your 
own, according to the configuration of your supercomputer.

Modules required :
  - puppetlabs/apache (>= 1.1.1)
  - edf-hpc/hpclib

### Beginning with slurmweb


## Usage

Include the slurmweb class.

## Limitations

This module is only tested on Debian, as there's no official rpm packaged 
version of slurmweb. However it should operate with few modifications 
(and a rpm package) on RHEL and derivatives distributions.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
