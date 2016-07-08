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
# * `profiles::auth::client::enable_kerberos`
# * `profiles::openssh::server::config_augeas` (`hiera_array`)
# * `profiles::openssh::server::config_augeas_with_kerberos` (`hiera_array`)
class profiles::openssh::server {

  ## Hiera lookups
  $config_augeas               = hiera_array('profiles::openssh::server::config_augeas')
  $config_augeas_with_kerberos = hiera_array('profiles::openssh::server::config_augeas_with_kerberos')
  $cluster                      = hiera('cluster') 
  $enable_kerberos              = hiera('profiles::auth::client::enable_kerberos')

  if $enable_kerberos {
    $config_augeas_final = union($config_augeas,$config_augeas_with_kerberos)
  }
  else {
    $config_augeas_final = $config_augeas
  }

  # Pass config options as a class parameter
  class { '::openssh::server':
    config_augeas => $config_augeas_final,
    cluster       => $cluster,
  }
}
