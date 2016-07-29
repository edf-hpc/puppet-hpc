# sudo

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What sudo affects](#what-sudo-affects)
    * [Beginning with sudo](#beginning-with-sudo)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure the sudo program, to enable running programs with the security privileges of another user. 

## Module Description

This module installs sudo and edits its configuration file.

## Setup

### What sudo affects

* sudo package
* sudoers file

### Beginning with sudo

This installs the sudo package with a basic configuration file

```
include sudo
```

## Usage

It is possible to add lines to the sudoers file by specifying them in the config_options array as shown below.

```
  $sudo_lines = [
    '%sudo ALL=(ALL) ALL',
    'includedir /etc/sudoers.d',
  ]
  # Pass config options as a class parameter
  class { '::sudo':
    config_options => $sudo_lines,
  }
```

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.
The default sudoers file is basic.

## Development
 
Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
