# hpc_rsyslog

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What hpc_conman affects](#what-flexlm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hpc_conman](#beginning-with-flexlm)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

This module deploys resources complementary to saz-rsyslog community module on
rsyslog servers.

## Setup

### What hpc_rsyslog affects

The module deploys logrotate rules configuration and systemd drop-in service
configuration override.

### Setup Requirements

The module depends on:

* `stdlib` module (for `validate_*()` and `deep_merge()` functions),
* `hpclib` module (for `print_config()` defined type)

### Beginning with hpc_rsyslog

## Usage

The module has one public class `::hpc_rsyslog::server` which can be called like
this:

```
class { "::hpc_rsyslog::server":
  logrotate_rules => {
    remotelog => {
      path          => '/srv/logs/*',
      compress      => true,
      missingok     => true,
      copytruncate  => true,
      create        => false,
      delaycompress => true,
      mail          => false,
      rotate        => '30',
      sharedscripts => true,
      size          => '5M',
      rotate_every  => day,
      postrotate    => 'invoke-rc.d rsyslog rotate > /dev/null',
    }
  },
  service_override => {
    'Service' => {
      'LimitNOFILE' => '16384'
    }
  },
}
```

The `logrotate_rules` parameter is a hash of logrotate rules definitions to
deploy. This `remotelog` rule is deployed by default by the module. The
defaults parameters of this rule can be altered by overriding them in the class
arguments since the `logrotate_rules` hash is deep-merged with default rule
definition from `params` private class. Other rules can be appended into the
hash.

The `service_override` parameter is a hash of a drop-in systemd service
configuration file containing to override default rsyslog service settings. The
default drop-in systemd service configuration file defined in `params` private
class sets rsyslog soft maximum open fd limit to 8192.

## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
