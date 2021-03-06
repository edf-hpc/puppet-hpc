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

# Common profile for all cluster node
#
# ## Hiera
# * `libcalibre`
# * `profiles::cluster::root_password_hash`
# * `profiles::cluster::apt_sources` (`hiera_hash`) APT repository sources
#                                    as defined by `apt::source`
# * `profiles::cluster::apt_confs` (`hiera_hash`) APT configs as defined by
#                                  `apt::conf`
# ## Relevant Autolookup
# * `fusioninventory::config_options`  Parameters used to build config file for FusionInventory Agent
# * `fusioninventory::default_options` Parameters used to build default file for FusionInventory Agent
class profiles::cluster::common {
  # Setup staging
  stage { 'first': }
  stage { 'last': }
  Stage['first'] -> Stage['main'] -> Stage['last']

  # Set the root password
  $root_password = hiera('profiles::cluster::root_password_hash')
  class { '::hpc_user::root':
    password => $root_password,
    stage    => 'first',
  }

  # Set apt config
  if $::osfamily == 'Debian' {
    $apt_sources = hiera_hash('profiles::cluster::apt_sources')
    $apt_confs   = hiera_hash('profiles::cluster::apt_confs', {})
    class { '::hpc_apt':
      stage   => 'first',
      confs   => $apt_confs,
      sources => $apt_sources,
    }

    Class['::apt::update'] -> Package<| title != "apt-transport-https" |>
  }

  if $::osfamily == 'RedHat' {
    $yumrepos = hiera_hash('profiles::cluster::yumrepos')
    class { '::hpc_yum':
      stage => 'first',
      repos => $yumrepos,
    }
  }

  # Disable the Puppet agent
  class { '::puppet':
    stage     => 'first',
  }

  # Create /var/lib/calibre or equivalent
  $libcalibre_path = hiera('libcalibre')
  file { $libcalibre_path:
    ensure => directory
  }

  # Install FusionInventory Agent
  class { '::fusioninventory':
  }

}
