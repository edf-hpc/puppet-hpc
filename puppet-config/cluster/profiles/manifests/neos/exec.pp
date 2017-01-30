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

# Neos on an exec host
#
# On exec node, this profiles also install `neos-slurm-graphical-plugins`.
# This package sets an epilog scripts that reset the node X server state.
#
# ## Hiera
# * `profiles::neos::config_options` (`hiera_hash`) Content of the config
#       file for '/etc/neos.conf'.
class profiles::neos::exec {
  $packages = [
    'neos-slurm-graphical-plugins',
    'xfce4',
    'x11vnc',
  ]
  ensure_packages($packages)

  $config_options = hiera_hash('profiles::neos::config_options')
  class { '::neos':
    config_options => $config_options,
  }
}
