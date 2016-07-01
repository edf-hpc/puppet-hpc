# clara

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

Install and configure clara. A Cluster administration tool.

## Module Description

This module install clara and generate a usable configuration. 

## Setup

### What clara affects

### Setup Requirements

This module provides a default keyring, but it should be replaced by your own
keyring.

### Beginning with clara

If you wish to use the local repositories feature, you must provide a keyring.
The example below, show how the default keyring was generated (the
passphrase used is `passphrase`):

```
LANG=C gpg --no-default-keyring --keyring puppet-config/modules/clara/files/cluster_keyring.gpg --secret-keyring puppet-config/modules/clara/files/cluster_keyring.secret.gpg --gen-key
gpg (GnuPG) 1.4.18; Copyright (C) 2014 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048)
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y

You need a user ID to identify your key; the software constructs the user ID
from the Real Name, Comment and Email Address in this form:
    "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

Real name: Puppet HPC Cluster TEST keyring
Email address: gochangeit@hpc.example.com
Comment: YOU should feel bad to use this in production. This test keyring should be regenerated on your cluster. You can change its source with the $keyring_source parameter for the clara puppet class.
You selected this USER-ID:
    "Puppet HPC Cluster TEST keyring (YOU should feel bad to use this in production. This test keyring should be regenerated on your cluster. You can change its source with the $keyring_source parameter for the clara puppet class.) <gochangeit@hpc.example.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
You need a Passphrase to protect your secret key.

We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
.........+++++
...+++++
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
....+++++
.............................+++++
gpg: key 1F2607DD marked as ultimately trusted
public and secret key created and signed.

gpg: checking the trustdb
gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
gpg: depth: 0  valid:   2  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 2u
pub   2048R/1F2607DD 2016-05-18
      Key fingerprint = CC89 E5BB 31BD A97E C06E  F524 3853 7B55 1F26 07DD
uid                  Puppet HPC Cluster TEST keyring (YOU should feel bad to use this in production. This test keyring should be regenerated on your cluster. You can change its source with the $keyring_source parameter for the clara puppet class.) <gochangeit@hpc.example.com>
sub   2048R/A396C996 2016-05-18
```

## Usage

Include the clara class.

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc
