# icinga2

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What icinga2 affects](#what-icinga2-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with icinga2](#beginning-with-icinga2)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Installs and configure Icinga2 satellite and agent configuration roles for
distributed monitoring setup on HPC cluster with external central Icinga2
monitoring server.

## Setup

### What icinga2 affects

The module notably affects the following resources:

* Monitoring packages
* Icinga2 configuration files
* API listener host SSL certificate/key with CA certiticate
* identities files containing passwords and keys
* Icinga2 system service

### Setup Requirements

This module depends on the following modules:

* stdlib (for `validate_*()` and `*merge()` functions)
* hpclib (for `decrypt()` and `hpc_source_file()` functions)

### Beginning with icinga2

## Usage

Here is an example instanciation of `icinga2` public class for a pair of
redundant monitoring satellites `monitoring[1-2].cluster.tld` with a central
monitoring master `monitoring-master.company.tld`:

```
class { '::icinga2':
    features      => [ 'api', 'livestatus', 'command'],
    features_conf => {
      api => {
        accept_config => true,
        accept_commands => true,
      },
    },
    zones         => {
      master => {
        endpoints => [ 'monitoring-master.company.tld' ],
      },
      cluster => {
        parent => 'master',
        endpoints => [ 'monitoring1.cluster.tld',
                       'monitoring2.cluster.tld', ],
      },
    }
    endpoints     => {
      'monitoring-master.company.tld' => {},
      'monitoring1.cluster.tld' => {
        host =>  'monitoring1.cluster.tld',
      },
      'monitoring2.cluster.tld' => {
        host =>  'monitoring2.cluster.tld',
      },
    },
    idents        => {
      passwords => "%{hiera('private_files_dir')}/icinga2/idents/passwords.enc",
    },
    crt_host_src  => "%{hiera('private_files_dir')}/icinga2/certs/%{::hostname}.crt"
    key_host_src  => "%{hiera('private_files_dir')}/icinga2/certs/%{::hostname}.key.enc"
    crt_ca_src    =>  "%{hiera('private_files_dir')}/icinga2/certs/ca.crt"
    decrypt_passwd => "%{hiera('cluster_decrypt_password')}"
}
```

The following features are enabled with the `features` argument:

* the API listener (required for distributed setups),
* the livestatus API for getting quick status of checks through simple HTTP
  requests,
* the command feature to send commands (suck as passive check results) through
  a named pipe.

Some additional parameters are provided for feature `api` with the
`features_conf` argument.

The `zones` and `endpoints` arguments are defined to configure a satellite in an
Icinga2 distributed setup. Please refer to Icinga2 official and reference
documentation for more background and details about highly-available distributed
setups with master, satellite and agents configuration settings.

An encrypted file containing passwords used for monitoring purpose is deployed
with `idents` argument. This password file can then be used by monitoring
plugins to access any resource, such as network equipments.

Then, some URL to respectively host certifcate, host key and CA certificate are
given for the Icinga2 API PKI.

Finally, the encryption password used to decrypt the identities password file
and the SSL host key is provided with the `decrypt_password` argument.

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
