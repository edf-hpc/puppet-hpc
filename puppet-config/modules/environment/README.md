# environment

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What environment affects](#what-environment-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with environment](#beginning-with-environment)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Configure user environment on an HPC cluster node.

## Module Description

This modules configure user environment on an HPC cluster node used by the the
end user. Its sets up environment variables, MOTD, SSH keys...

## Setup

### What environment affects

This module sets up:
 - system shell configuration (/etc/bash.bashrc and /etc/profile.d)
 - systemd-user-session
 - ssh keys generation script for users
 - MOTD

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with environment

## Usage

Include the class:

```
class{ '::environment':
  motd_content => {
    'info' => [
      'Welcome to this System',
      $::hostname,
    ],
    'legal' => [
      'No Trespassing',
    ],
  },
  cluster => 'Leviathan',
  authorized_users_groups => 'rd,engineering',
}
```  

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
