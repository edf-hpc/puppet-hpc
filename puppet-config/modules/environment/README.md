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
 - login.defs
 - (optional) Logging of user commands

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with environment

## Usage

Include the class:

```
class{ '::environment':
  motd_content            => {
    'info' => [
      'Welcome to this System',
      $::hostname,
    ],
    'legal' => [
      'No Trespassing',
    ],
  },
  cluster                 => 'Leviathan',
  authorized_users_groups => 'rd,engineering',
  login_defs_options      => {
    'UMASK' => '077',
  },
}
```  

The `log_commands_enable` parameter sets up a `COMMAND_PROMPT` variable that
logs the history of users. This features is meant to forward these logs to a
SOC. By default logs are sent to the `local6` facility, this can be changed
with `log_commands_facility`.

## Limitations

This module is mainly tested on Debian.

The `service` class is tested on RedHat (RHEL, CentOS...).

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
