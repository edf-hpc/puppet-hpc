# S3cmd 

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What s3cmd affects](#what-s3cmd-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with s3cmd](#beginning-with-cce)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description

Configures s3cmd command

s3cmd is a tool for managing Amazon S3 storage space and Amazon CloudFront 
content delivery network.

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with hpcconfig

## Usage

Include the s3cmd on required nodes.

's3cmd::config_options' must be provided to have a fully-functionnal 
configuration.

## Limitations

This module is mainly tested on Debian, s3cmd is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
