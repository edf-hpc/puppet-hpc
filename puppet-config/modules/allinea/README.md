# allinea

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with allinea](#beginning-with-allinea)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description
Install and configure the Allinea Licensing server

## Setup

### Setup Requirements

This module depends on:

* ``hpclib``

### Beginning with allinea


Just include the class to deploy the server without a license file:

```
include ::allinea::licensing
```

## Usage

The license file can be configured by any mean, it can be deployed in the
directory: ``/opt/allinea-licenseserver/licences``

There is a default mechanism that uses the ``decrypt()`` function from
``hpclib``. You must provide a source location for the encrypted file and a
decrypt password to use it.


```
class{'::allinea::licensing':
  lic_enc        => 'http://files.hpc.example.com/allinea/licence.enc',
  decrypt_passwd => 'passw0rd',
}
```

## Limitations

The module is only tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
