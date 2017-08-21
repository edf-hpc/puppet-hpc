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

class pam::umask::config inherits pam::umask {

  # direct file modification for Debian
  case $::osfamily {
    'Debian': {
      pam { 'umask Definition':
        ensure   => present,
        provider => augeas,
        service  => $::pam::umask::pam_service,
        type     => $::pam::umask::type,
        module   => $::pam::umask::module,
        control  => $::pam::umask::control,
        position => $::pam::umask::position,
      }
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}, should be 'Debian'.")
    }
  }

}
