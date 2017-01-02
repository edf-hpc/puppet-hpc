# openldap

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with openldap](#beginning-with-openldap)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Installs ldap and setup script to configure a replica

Provides a class to setup a local OpenLDAP server, another class sets-up a 
script that can be called to synchronize with an external ldap replica.

# Setup

### Setup Requirements

This module uses hpclib functions.

### Beginning with openldap

The base openldap class (the server alone) do not need any particular
parameter.


```
include ::openldap

```

## Usage

### Replica

The ``openldap::replica`` class is used to:

- Setup a script to create a replica (``make_ldap_replica.sh``)
- Download an encrypted LDIF file to configure the replica

Launching the script is a manual operation, that must be performed on node
bootstrap or if the LDIF file needs to be reloaded.

It is a manual operation because, the script will destroy the local database
and rebuild it from scratch.

```
class{'::openldap::replica':
  ldif_file      => 'example.ldif',
  directory_file => 'http://files.hpc.example.com/private/auth',
  decrypt_passwd => 'passw0rd',
}
```

## Limitations

This module is tested on Debian.

## Development

Patches and issues can be submitted on github:
https://github.com/edf-hpc/puppet-hpc

