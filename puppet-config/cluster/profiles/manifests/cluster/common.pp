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

# Common profile for all cluster node
#
# ## Hiera
# * `libcalibre`
# * `profiles::cluster::root_password_hash`
class profiles::cluster::common {
  # Set the root password
  $root_password = hiera('profiles::cluster::root_password_hash')
  user { 'root':
    ensure   => present,
    password => $root_password,
  }

  # Create /var/lib/calibre or equivalent
  $libcalibre_path = hiera('libcalibre')
  file { $libcalibre_path:
    ensure => directory
  }

  # Set apt config
  $always_apt_update    = hiera('profiles::cluster::always_apt_update')
  $disable_keys         = hiera('profiles::cluster::disable_keys')
  $purge_sources_list   = hiera('profiles::cluster::purge_sources_list')
  $purge_sources_list_d = hiera('profiles::cluster::purge_sources_list_d')
  $purge_preferences_d  = hiera('profiles::cluster::purge_preferences_d')
  $update_timeout       = hiera('profiles::cluster::update_timeout')
  $apt_sources          = hiera_hash('profiles::cluster::apt_sources')

  if $::osfamily == 'Debian' {
    class { 'apt':
      always_apt_update    => $always_apt_update,
      disable_keys         => $disable_keys,
      purge_sources_list   => $purge_sources_list,
      purge_sources_list_d => $purge_sources_list_d,
      purge_preferences_d  => $purge_preferences_d,
      update_timeout       => $update_timeout,
    }
  }

  create_resources(apt::source, $apt_sources)
}
