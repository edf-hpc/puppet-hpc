##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2017 EDF S.A.                                      #
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
# * `domain`
# * `boot_params`
# * `profiles::bootsystem::tftp_config_options` Configuration hash of TFTP
#                                               server (default: {})
# * `profiles::bootsystem::tftp_dir`
#
# ## Relevant Autolookups
# * `boothttp::menu_source`
# * `boottftp::ipxe_efi_source`
# * `boottftp::ipxe_legacy_source`
class profiles::bootsystem::server {

  $prefix          = hiera('cluster_prefix')
  $domain          = hiera('domain')
  $virtual_address = $::hostfile["${prefix}${::puppet_role}"]

  $tftp_config_options = hiera_hash('profiles::bootsystem::tftp_config_options', {})

  class { '::tftp':
    config_options     => $tftp_config_options,
  }

  class { '::boottftp':
  }

  $menu_config_options = hiera_hash('boot_params', {})
  $servername = "${prefix}${::puppet_role}"
  $serveraliases = ["${servername}.${domain}"]

  include ::apache

  class { '::boothttp':
    virtual_address     => $virtual_address,
    servername          => $servername,
    serveraliases       => $serveraliases,
    menu_config_options => $menu_config_options,
  }

}
