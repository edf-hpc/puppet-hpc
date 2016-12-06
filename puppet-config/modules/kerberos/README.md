# kerberos

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What kerberos affects](#what-kerberos-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kerberos](#beginning-with-kerberos)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description
Install and configure kerberos clients

This makes the base configuration for kerberos clients on this system
(`krb5.conf` and host keytab file). It does not configure final services
like sshd or sssd.

## Setup

### What kerberos affects

Set `krb5.conf` content and default keytab path.

### Setup Requirements

This module uses stdlib and hpclib `decrypt()` function.

### Beginning with kerberos

## Usage

```
class{'::kerberos':
  config_options => {
    'libdefaults' => {
      'default_realm'    => 'HPC.EXAMPLE.COM',
      'rdns'             => 'false',
      'dns_lookup_realm' => 'false',
      'dns_lookup_kdc'   => 'false',
      'forwardable'      => 'true',
    },
    'realms' => {
      'HPC.EXAMPLE.COM' => "
      {
        kdc = kdc1.hpc.example.com
        kdc = kdc2.hpc.example.com
        admin_server = kerberos.hpc.example.com
        kpasswd_server = kerberos.hpc.example.com
        default_domain = hpc.example.com
      }",
    },
    'domain_realm' => {
      '.example.com' => 'HPC.EXAMPLE.COM',
      'example.com'  => 'HPC.EXAMPLE.COM',
    },
  },
  decrypt_passwd => 'passW0rd',
}
```

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
