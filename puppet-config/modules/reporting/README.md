# reporting

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What cce affects](#what-cce-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with cce](#beginning-with-cce)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description

Configures reporting

Reporting is a set of tools for performing different user reports, quotas, and cluster usage.

## Setup

### Setup Requirements

This module uses stdlib.

### Beginning with cce

## Usage

```
class { '::reporting':

  config_options => {
    'send_from': ''
  }

  config_report_users => {
    'cron_grp_ldap':
         'cron_cluster': ''
         'cron_exe_user': ''
         'cron_destinataire': ''
         'cron_destinataire_copie': ''
  }
}
```

## Limitations

This module is mainly tested on Debian is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
