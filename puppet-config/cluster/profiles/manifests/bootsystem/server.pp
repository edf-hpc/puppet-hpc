##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2016 EDF S.A.                                      #
#  Contact: CCN-HPC <dsp-cspit-ccn-hpc@edf.fr>                           #
#                                                                        #
#  This program is free software; you can redistribute in and/or         #
#  modify it under the terms of the GNU General Public License,          #
#  version 2, as published by the Free Software Foundation.              #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
##########################################################################

# Setup tftp and an http server for boot system
#
# ## Hiera
# * `cluster_prefix`
# * `profiles::bootsystem::tftp_config_options` (`hiera_hash`)
# * `profiles::bootsystem::tftp_dir`
# * `profiles::bootsystem::ipxe_efi_source`
# * `profiles::bootsystem::ipxe_leg_source`
# * `profiles::bootsystem::http_dir`
# * `profiles::bootsystem::menu_source`
# * `profiles::bootsystem::http_disk_source`
# * `profiles::bootsystem::supported_os`
class profiles::bootsystem::server {

  $prefix          = hiera('cluster_prefix')
  $virtual_address = $::hostfile["${prefix}${::puppet_role}"]

  # Install and configure the server tftp
  $tftp_config_options = hiera_hash('profiles::bootsystem::tftp_config_options')

  class { '::tftp':
    config_options     => $tftp_config_options,
  }

  # Install files necessary for boot
  $config_dir_ftp      = hiera('profiles::bootsystem::tftp_dir')
  $ipxe_efi_source     = hiera('profiles::bootsystem::ipxe_efi_source')
  $ipxe_legacy_source  = hiera('profiles::bootsystem::ipxe_leg_source')

  class { '::boottftp':
    config_dir_ftp             => $config_dir_ftp,
    ipxe_efi_source            => $ipxe_efi_source,
    ipxe_legacy_source         => $ipxe_legacy_source,
  }

  $config_dir_http     = hiera('profiles::bootsystem::http_dir')
  $menu_source         = hiera('profiles::bootsystem::menu_source')
  $disk_source         = hiera('profiles::bootsystem::http_disk_source')
  $supported_os        = hiera('profiles::bootsystem::supported_os')

  class { '::boothttp':
    config_dir_http            => $config_dir_http,
    menu_source                => $menu_source,
    disk_source                => $disk_source,
    supported_os               => $supported_os,
    virtual_address            => $virtual_address,
  }

}
