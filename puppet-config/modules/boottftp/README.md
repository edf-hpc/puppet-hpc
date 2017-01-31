# boottftp

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What boottftp affects](#what-boottftp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with boottftp](#beginning-with-boottftp)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Setup boot and install files served over TFTP

On a Scibian HPC cluster, the boot or install process needs to retrieve some
resources through TFTP. On a typical installation, its mainly the iPXE binary,
other configuration is sent via HTTP (see: ``boothttp``).

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with boottftp


The default configuration will not deploy any file and just configure the
directory:

```
include ::boottftp
```

## Usage

The basic configuration below configures a pair of iPXE binaries.
```
class { '::boottftp':
  hpc_files => {
    '/srv/tftp/ipxe_noserial.bin' => {
      'source' => "http://files.hpc.example.com/boot/ipxe/ipxe_noserial.bin",
    },
    '/srv/tftp/ipxe_serial.bin' => {
      'source' => "http://files.hpc.example.com/boot/ipxe/ipxe_serial.bin",
    },
  }
}
```

## Limitations

This module is mainly tested on Debian, boottftp is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
