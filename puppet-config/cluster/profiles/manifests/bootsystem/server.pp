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
# * `local_domain`
# * `profiles::bootsystem::tftp_config_options` (`hiera_hash`)
# * `profiles::bootsystem::tftp_dir`
# * `profiles::bootsystem::http_dir`
# * `profiles::bootsystem::http_port`
# * `profiles::bootsystem::supported_os`
# * `profiles::bootsystem::boot_params`
#
# ## Relevant Autolookups
# * `boothttp::menu_source`
# * `boottftp::ipxe_efi_source`
# * `boottftp::ipxe_legacy_source`
class profiles::bootsystem::server {

  $prefix          = hiera('cluster_prefix')
  $local_domain    = hiera('local_domain')
  $virtual_address = $::hostfile["${prefix}${::puppet_role}"]

  # Install and configure the server tftp
  $tftp_config_options = hiera_hash('profiles::bootsystem::tftp_config_options')

  class { '::tftp':
    config_options     => $tftp_config_options,
  }

  class { '::boottftp':
  }

  $config_dir_http     = hiera('profiles::bootsystem::http_dir')
  $supported_os        = hiera('profiles::bootsystem::supported_os')
  $menu_config_options = hiera('profiles::bootsystem::boot_params')

  class { '::boothttp':
    config_dir_http     => $config_dir_http,
    supported_os        => $supported_os,
    virtual_address     => $virtual_address,
    menu_config_options => $menu_config_options,
  }

  $port = hiera('profiles::bootsystem::http_port')

  $servername = "${prefix}${::puppet_role}"
  $serveraliases = ["${servername}.${local_domain}"]
  include apache
  apache::vhost { "${servername}_bootsystem":
    servername    => $servername,
    port          => $port,
    docroot       => $config_dir_http,
    scriptalias   => "${config_dir_http}/cgi-bin",
    serveraliases => $serveraliases,
    docroot_mode  => '0750',
    docroot_group => 'www-data',
  }

}
