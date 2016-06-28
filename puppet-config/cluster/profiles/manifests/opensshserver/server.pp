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

# Configure the local SSH server 
#
# If Kerberos authentication is enabled on this host, it will be enabled
# in the SSH server configuration.
#
# ## Hiera
# * `cluster`
# * `profiles::opensshserver::main_config_options`
# * `profiles::opensshserver::main_config_options_with_kerberos`
# * `profiles::opensshserver::directory_source`
# * `profiles::auth::client::enable_kerberos`
class profiles::opensshserver::server {

  ## Hiera lookups

  $main_config_options               = hiera_array('profiles::opensshserver::main_config_options')
  $main_config_options_with_kerberos = hiera_array('profiles::opensshserver::main_config_options_with_kerberos')
  $cluster                           = hiera('cluster') 
  $directory_source                  = hiera('profiles::opensshserver::directory_source')
  $enable_kerberos                   = hiera('profiles::auth::client::enable_kerberos')


  if $enable_kerberos {
    $sshd_config_options = union($main_config_options,$main_config_options_with_kerberos)
  }
  else {
    $sshd_config_options = $main_config_options
  }

  # Pass config options as a class parameter
  class { '::opensshserver':
    sshd_config_options => $sshd_config_options,
    cluster             => $cluster,
    directory_source    => $directory_source,
  }
}
