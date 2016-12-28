# filesystem

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What filesystem affects](#what-filesystem-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with filesystem](#beginning-with-filesystem)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

## Module Description

Wrapper module for filesystem related resources: symlinks, mounts, directories...

This module defines some common resources to build the base filesystem state. 

## Setup

### Setup Requirements

This module relies on the Puppetlabs stdlib module.

## Usage

```
class{ '::filesystem::mounts':
  mounts => {
    '/tmp' => {
      ensure   => 'mounted',
      atboot   => true,
      device   => '/dev/md127p1',
      fstype   => 'ext4',
      remounts => false,
  }
}

class{ '::filesystem::directories':
  directories => {
    '/data' => {}
  }
}

class{ '::filesystem::symlinks':
  symlinks => {
    '/home' => {
      target  => '/data/home',
  }
}
```

## Limitations

This module is mainly tested on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
