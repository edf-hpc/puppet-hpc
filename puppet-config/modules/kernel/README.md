# kernel

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What kernel affects](#what-kernel-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kernel](#beginning-with-kernel)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

The module setup Linux kernel subsystems.

## Setup

### What kernel affects

* Sysctl parameters
* Udev rules

### Setup Requirements

The module depends on:

* `stdlib` module (for `validate_*()` function),
* `hpclib` module (for `hpclib::print_config()` defined type),

### Beginning with kernel

N/A

## Usage

The kernel module has one public class `kernel`. It accepts udev rules and
sysctl parameters as hashes. For exemple:

```
class { '::kernel':
  sysctl => {
    core => {
       params => {
         'kernel.pid_max' => '65536',
         'kernel.msgmnb'  => '65536',
         'kernel.msgmax'  => '65536',
         'vm.swappiness'  => '0',
       },
    },
    conntrack'=> {
      module => 'nf_conntrack',
      prefix => '/proc/sys/net/netfilter',
      params => {
        'net.netfilter.nf_conntrack_max' => '524288'
      },
    },
  },
  udev_rules => {
    'custom' => {
      rules => [ "ACTION==\"add\", SUBSYSTEM==\"module\" ],
    },
  },
}
```

If a sysctl hash has a module and prefix key, it also creates a udev rule to
load the respective sysctl parameters (with `systemd-sysctl`) once the module
is loaded. It is the recommended way to setup sysctl parameters that depends
on kernel module at boot time, as explained at this URL:

https://www.freedesktop.org/software/systemd/man/sysctl.d.html

## Limitations

This module is supported on Debian and RedHat 6 and derivatives.

Sysctl udev rules are not supported on RedHat 6 and derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
