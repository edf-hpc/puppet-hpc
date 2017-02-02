# boothttp

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What boothttp affects](#what-boothttp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with boothttp](#beginning-with-boothttp)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

Setup boot and install files served over HTTP

On a Scibian HPC cluster, the boot or install process needs to retrieve some
resources through HTTP. This include:

 * iPXE boot menu (a python CGI)
 * The installer itself
 * Resources used by the installer: config files, preseed/kickstart...

The installer configuration uses a list of supported os, the default list only
includes `calibre9`.

The module setup the files to serve and the virtual host configuration of the
HTTP server (apache).

## Setup

### Setup Requirements

This module uses stdlib and hpclib.

### Beginning with boothttp

The basic configuration below configures a iPXE boot menu, a Debian (calibre)
installer and redirect to a diskless boot.

The ``bootmenu.py`` file should be provided in the cluster private files. The
example below does not include the full preseed file. The preseed file should
follow the format for the Debian version.

```
class { '::boothttp':
  $virtual_address     => 'clservice',
  $servername          => 'clservice',
  $serveraliases       => [ 'clservice.hpc.example.com' ],
  $port                => '3138',
  $config_dir_http     => '/var/www',
  $supported_os        => [ 'calibre9' ],
  $menu_config         => '/etc/hpc-config/bootmenu.yaml',
  $menu_source         => 'http://files.hpc.example.com/boot/cgi/bootmenu.py',
  $menu_config_options => {
    'defaults' => {
      'domain'             => 'cluster.hpc.example.com',
      'kernel_opts'        => 'persistence formatcow nosmap',
      'cowsize'            =>  '2G',
      'dhcp_timeout'       => '120',
      'diskinstall_server' => 'clservice',
      'diskless_server'    => 'clp2p',
      'nameserver'         => '172.16.18.0',
      'boot_os'            => 'calibre9_ram',
      'boot_dev'           => 'eth0',
      'console'            => 'ttyS0,115200n8',
      'disk_raid'          => '',
      'disk_format'        => '',
    },
    'clservice[1-4],clp2p[1-2]' => {
      'boot_os'  => 'calibre9_disk',
      'boot_dev' => 'eth2',
      'console'  => 'ttyS1,115200n8',
      'ipxebin'  => 'ipxe_noserial.bin',
    },
  },
  $install_options     => {
    'calibre9' => {
      'd-i debian-installer/locale string'   => 'en_US.UTF-8',
      'd-i debian-installer/language string' => 'en',
      <..full debian preseed..>
    },
  },
  hpc_files => {
    '/var/www/disk/calibre9/partition-schema' => {
      'source' => 'http://files.hpc.example.com/boot/disk-installer/calibre9/partition-schema',
    },
    '/var/www/disk/calibre9/hpc-config.conf' => {
      'source' =>'http://files.hpc.example.com/boot/disk-installer/calibre9/hpc-config.conf',
    },
  },
  archives => {
    '/var/www/disk/calibre9/netboot.tar.gz' => {
      'source'       => 'http://files.hpc.example.com/boot/disk-installer/calibre9/netboot.tar.gz',
      'extract_path' => '/var/www/disk/calibre9',
    },
  },
}
```

## Usage

The ``install_options`` provides parameters for all installers, with preseed
the data is used as-is in the preseed file. With kickstart files, the data is
injected with a template.

The ``menu_config_options`` depends of the format that the boot menu uses.

## Limitations

The boot menu is not provided directly by this module, the module only provides
option to deploy it.

This module is mainly tested on Debian, boothttp is not packaged on RHEL and
derivatives.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
