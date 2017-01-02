# postfix

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with postfix](#beginning-with-postfix)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description
Install and configure a Postfix MTA

## Setup

### Setup Requirements

This module depends on:

* ``hpclib``

### Beginning with postfix

The base configuration will work as a local MTA : only listen to localhost and
forward mail directly to SMTP server for the domain.

```
include ::postfix
```

## Usage

A relay host can be configured if the server where Postfix runs can't forward
directly to user SMTP servers.

On a cluster, some host also acts as relay for all mails coming from the
cluster, but postfix should be configured to listen on the local networks.

```
class{'::postfix':
  config_options => {
    'inet_interfaces'     => 'all',
    'relay_domains'       => '$mydestination example.com',
    'relayhost'           => 'smtp.example.com',
  },
}
```

## Limitations

The module is only tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc