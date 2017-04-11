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

class network::install inherits network {

  if $::network::install_manage {

    if $::network::packages_manage {
      package { $::network::_packages:
        ensure => $::network::packages_ensure,
      }
    }

    # on Debian, install additional ifupdown run-parts scripts
    if $::osfamily == 'Debian' {
      # Files are delivered by the module and installation is hard-coded without
      # any possibility to customize this because there is no reason to change
      # and/or adapt this behaviour since it should works in all cases.
      ::network::ifupdown_part { ['killdhclient', 'ibmode']:
        step => 'pre-up',
      }
    }

  }

}
