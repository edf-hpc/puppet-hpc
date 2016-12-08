# certificates

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What certificates affects](#what-certificates-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with certificates](#beginning-with-certificates)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Deploy certificates on nodes for LDAP.

## Module Description

This module install certificates (.crt and .key) on nodes.

## Setup

### What certificates affects

LDAP will not work without certificate (sssd config and sssd.service). It deploy certificate and key for LDAP.

### Setup Requirements

-

### Beginning with certificates

## Usage

On openldap replicat:
```
include certificates
```

On openldap client:
```
include certificates
```

## Limitations

This module does not manage other certificate (like clara) only valid for LDAP certificates.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
