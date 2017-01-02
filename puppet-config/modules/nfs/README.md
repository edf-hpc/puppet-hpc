# nfs

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What nfs affects](#what-nfs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nfs](#beginning-with-nfs)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description
Install and configure NFS client or server, manages mount and exports.

The modules define a class for the server and one for the client. The module
defines resources type that can be used to mount NFS exports on the client and
to define new exports on the server.

## Setup

### Setup Requirements

This module uses the concat Puppet modules.

### Beginning with nfs

## Usage

### Server

* Include the class `::nfs::server`
* Define exports with the resource `::nfs::server::export`

```
::nfs::server::export{'data':
  exportdir  => '/data',
  options    => 'rw,sync',
}

```

### Client

* Include the class `::nfs`
* Define exports with the resource `::nfs::client::mount`

```
::nfs::client::mount{'nas':
  server     => 'nas.hpc.example.com',
  exportdir  => '/unix/',
  mountpoint => '/mnt/.nas',
  options    => 'sec=krb5,bg,rw,hard,timeo=20,vers=4',
}

```

### Kerberos

Kerberos must be configured separatly (by the kerberos module) before starting
the NFS service. You can request this module to load the gssd service though by
setting ``enable_gssd`` to true.

### Idmapd

For NFSv4 it is mandatory to have a working idmapd configuration, the
most basic setup is for all the nodes to use the same idmapd domain.

By default, idmapd will use the local domain name (``hostname -d``). If
you wish to override this setting you can add a ``idmapd_options``:

```
class{ '::nfs':
  idmapd_options => {
    'General' => {
      'Domain' => {
        'comment' => 'Domain for the mapping',
        'value'   => 'hpc.example.edu',
      },
    },
  },
}
```


## Limitations

This module is mainly tested on Debian, but is meant to also work with RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
