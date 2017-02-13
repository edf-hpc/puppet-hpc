# shorewall

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What shorewall affects](#what-shorewall-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with shorewall](#beginning-with-shorewall)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Configures a Shorewall firewall

Shorewall is a daemon that configures a linux firewall with a set of simple
rules. This modules installs and configures the daemon, and provides defined
resources to setup:

- zones
- interfaces
- policies
- rules
- masquerading

## Setup

### Setup Requirements

This module uses:
 * stdlib
 * hpclib
 * concat

### Beginning with shorewall

A minimal shorewall configuration needs to define zones, interface, policies
and optionnaly some rules. The example below sets up a firewall forbiding all
connection from the outside world except SSH and authorize all outgoing
connections. The target machine only has a single ``eth0`` interface.

```
include ::shorewall

::shorewall::zone { 'fw':
  type => 'firewall',
}
::shorewall::zone { 'wan':
  type => 'ipv4',
}

::shorewall::interface { 'eth0':
  zone => 'wan',
}

::shorewall::policy { 'from_ext':
  source => 'wan',
  dest   => 'fw',
  policy => 'REJECT',
  order  => '1',
}
::shorewall::policy { 'other':
  source => 'all',
  dest   => 'all',
  policy => 'ACCEPT',
  order  => '11',
}

::shorewall::rule { 'ssh_from_ext':
  comment => 'SSH inbound is authorize for management',
  source  => 'wan',
  dest    => 'fw',
  proto   => 'tcp',
  dport   => '22',
  action  => 'ACCEPT',
  order  => '0',
}
```

## Usage

The module follows closely the configuration model of shorewall. The base
service is configured with the main class. Defaults of the base class should
only rarely be modified. The main parameter is ``ip_forwarding`` that enables
routing on the firewall. This parameter should be true if the host acts as a
router for other hosts.

All the other parameters are configured with resources, each resource is
basically a line of the configuration file. When it is significant, resources
have an order parameter that let shorewall know which rules should be handled
first.

#### Resource: zone

A zone permits the firewall to group traffic in classes like: private,
public... There is usually a zone ``firewall`` for the local firewall machine
itself.

http://shorewall.net/manpages/shorewall-zones.html

#### Resource: interface

A network interface can be defined to be associated with a zone. All traffic
coming or going out via this interface will be associated with a zone.

http://shorewall.net/manpages/shorewall-interfaces.html

#### Resource: policy

Policies are default rules applied for traffic between zones. Rules defined
here are applied if no specific rule matches.

http://shorewall.net/manpages/shorewall-policy.html

#### Resource: rules

The actual rules for the firewall. The rules can be defined in two ways, the
normal one is to provide the parameters like source and destination and let the
puppet module build the rule. The other way is to just provide the full rule
line in the ``rule`` parameter.

http://shorewall.net/manpages/shorewall-rule.html

#### Resource: masq

Masq are special rules that can be used to provided DNAT and SNAT capabilities
to the firewall.

http://shorewall.net/manpages/shorewall-masq.html

```

class { '::shorewall:masq':
  ip_forwarding => true,
}

::shorewall::masq { 'NAT':
  interface => 'eth0',
  source    => '192.168.12.0/24',
}
```

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
