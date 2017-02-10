# puppet

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What puppet affects](#what-puppet-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet](#beginning-with-puppet)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Configures the puppet agent

The point of this module is to provide a knob to disable the puppet agent
service. On Debian the service is started automatically when the package is
installed. Including this class stops and disable the puppet agent.

This is useful for puppet-hpc because puppet is used without a server.

## Setup

### Setup Requirements

This module uses stdlib.

### Beginning with puppet

Just include the main class:

```
include ::puppet
```

##Usage

The agent can be reenabled with standard parameters: ``service_ensure`` and
``service_enable``.

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
