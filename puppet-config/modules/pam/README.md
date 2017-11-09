# pam

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What pam affects](#what-clara-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pam](#beginning-with-pam)
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
* `mkhomedir`, create user directories on first login
* `pwquality`, check password quality when user changes passwords
* `slurm`, only authorizes users with a SLURM job on the node
* `sss`, authentication uses the sssd daemon
* `umask`, Activate umask settings during session init

## Setup

### What pam affects

Users authorized to use the system and user sessions.

### Setup Requirements

This module depends on:

* `hpclib`

### Beginning with pam

```
include ::pam
```

## Usage

### Access

Access create a list of rules to accept or reject connections by user, group
and origin (host, tty...). This class terminates its rules by a reject all
rule. It typically fills the file ``/etc/security/access.conf``.

```
class{'::pam::access':
  config_options => [
    '+ : root : 127.0.0.0/8',
    '+ : root : 10.1.1.0/24',
    '+ : root : 10.1.2.0/24',
    '+ : root : cron crond :0 ttyS0 ttyS1 tty1 tty2 tty3 tty4 tty5 tty6',
  ],
}
```

### Limits

The limits module configure ``rlimit`` applied to PAM sessions. It creates a
file ``/etc/security/limits.conf.d/puppet.conf``.

Data are given through a hash, but the key is discarded in the resulting file.

```
class{'::pam::limits':
  config_options => {
    'rss_soft'     => '*       soft    rss             unlimited',
    'rss_hard'     => '*       hard    rss             unlimited',
    'memlock_soft' => '*       soft    memlock         unlimited',
    'memlock_hard' => '*       hard    memlock         unlimited',
    'as_soft'      => '*       soft    as              unlimited',
    'as_hard'      => '*       hard    as              unlimited',
    'stack_soft'   => '*       soft    stack           unlimited',
    'stack_hard'   => '*       hard    stack           unlimited',
    'nofile_soft'  => '*       soft    nofile          16384',
    'nofile_hard'  => '*       hard    nofile          16384',
  },
}
```

### MKHomeDir

The module sets up a python script that is called to create the user
directories (home and scratch) when a user logs in for the first time.

With its default arguments, this module sets directories to be owned by
``root:root`` with an POSIX ACL to authorize the user to write in the directory.
This forbids the user to modify permission for his own home directory. The
module accepts the ``acl=False`` argument to behave like more classical mkhomedir
module: the owner of the directories (home and scratch) is the user and the
group is the primary group of the user, without POSIX ACL involved. This
argument can be set in the configuration file using 
``::pam::mkhomedir::config_options`` hash.

```
include ::pam::mkhomedir
```

### PWQuality

The pwquality module is used to check that password change respect company
policies.

The configuration can not be changed through the configuration, it is set as:

```
retry=3 minlen=8 difok=3 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=0
```

```
include ::pam::pwquality
```

### Slurm

The slurm module, when installed and enabled, block connection from user not
having a job on the node.

```
class{'::pam::slurm':
  module_enable => true
}
```

This setting is only applied when the package is installed (preseed).

### SSS

Activate authentication through SSSD, by installing the relevant PAM module.

```
include ::pam::sss
```

### Umask

Activate umask setting for the session, by installing the relevant PAM module.

```
include ::pam::umask
```

The actual umask value must be defined in `/etc/login.defs`, this can be set with
the `login_defs_options` parameter of the `::environment`` class of Puppet HPC.

## Limitations

Some modules do not supports Redhat:

* `limits`
* ``mkhomedir``
* `sss`
* `slurm`
* `pwquality`
* `umask`

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
