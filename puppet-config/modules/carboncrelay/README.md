# carboncrelay

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What carboncrelay affects](#what-carboncrelay-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with carboncrelay](#beginning-with-carboncrelay)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Configures carbon-c-relay

Carbon C Relay is a high performance relay for the Graphite (carbon) protocol.
It features: multiple destinations with rules, rewrite rules...

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with carboncrelay

On top of the base class, it is necessary to configure at least a destination
cluster and a match rule:

```
include ::carboncrelay

::carboncrelay::cluster{ 'graphite_cluster':
  destinations => {
    'graphite.example.com' => {
      'port' => '2003',
    },
  },
}

::carboncrelay::match{ 'catchall':
  expression   => '*',
  destinations => ['graphite_cluster'],
}
```

## Usage

### Resource: cluster

The cluster resource define a destination cluster for the metrics. A cluster is
defined by a set of destinations and a rule for choosing the destinations.


The ``destinations`` parameter accepts a hash:
```
  'hostA' => { 'port' => '2003' },
  'hostB' => { 'port' => '2003' },
  'hostC' => { 'port' => '2003' },
```

The types are:

* ``forward``: sends metrics to all destinations
* ``any_of``: each metric is sent to only one destination (load balancing)
* ``failover``: the metrics are sent to the first responding destination

### Resource: match

A match rule tells carbon-c-relay to send metrics matching a particular pattern
to a destination cluster.

Rules are applied in a specific order, so if a rule must be applied first the
orders should be tweaked. The rule can have a ``stop`` parameter that tells
carbon-c-relay to not look at following rules.

### Resource: rewrite

carbon-c-relay can be configured to rewrite metrics name. Since graphite
metrics are stored in a tree like structure. This permits to move metrics in
the tree before sending them to storage.

The following example move job metrics from a particular host to a specific tree
with all the job metrics:

```
# <cluster>.<node>.slurmd-job_36.cpu-user -> <cluster>.slurmd.<node>.job-36.cpu-user
::carboncrelay::rewrite { 'slurmd_host_swap':
  expression  => '^(.*)\.(.*)_?.*\.slurmd-(.*)\.(.*)$',
  replacement => '\1.slurmd.\2.\3.\4',
}
```

## Limitations

This module is mainly tested on Debian, carboncrelay is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
