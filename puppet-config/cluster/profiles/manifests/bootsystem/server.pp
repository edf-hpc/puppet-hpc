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
# * `profiles::bootsystem::http_dir`
# * `profiles::bootsystem::supported_os`
#
# ## Relevant Autolookups
# * `boothttp::menu_source`
# * `boottftp::ipxe_efi_source`
# * `boottftp::ipxe_legacy_source`
class profiles::bootsystem::server {

  $prefix          = hiera('cluster_prefix')
  $virtual_address = $::hostfile["${prefix}${::puppet_role}"]

  # Install and configure the server tftp
  $tftp_config_options = hiera_hash('profiles::bootsystem::tftp_config_options')

  class { '::tftp':
    config_options     => $tftp_config_options,
  }

  # Install files necessary for boot
  $config_dir_ftp     = hiera('profiles::bootsystem::tftp_dir')

  class { '::boottftp':
    config_dir_ftp     => $config_dir_ftp,
  }

  $config_dir_http = hiera('profiles::bootsystem::http_dir')
  $supported_os    = hiera('profiles::bootsystem::supported_os')

  class { '::boothttp':
    config_dir_http => $config_dir_http,
    supported_os    => $supported_os,
    virtual_address => $virtual_address,
  }

}
