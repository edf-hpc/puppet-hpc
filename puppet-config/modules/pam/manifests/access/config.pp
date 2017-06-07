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

class pam::access::config inherits pam::access {

  $options = concat($::pam::access::config_options, ['- : ALL : ALL'])
  hpclib::print_config { $::pam::access::config_file :
    style => 'linebyline',
    data  => $options,
    mode  => 0600,
  }

  # direct file modification for Debian, authconfig for RH
  case $::osfamily {
    'Debian': {
      pam { 'Access Definition':
        ensure   => present,
        provider => augeas,
        service  => $::pam::access::pam_service,
        type     => $::pam::access::type,
        module   => $::pam::access::module,
        control  => $::pam::access::control,
        position => $::pam::access::position,
      }
    }
    'RedHat': {
      exec { $::pam::access::exec:
        path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        command => $::pam::access::exec,
      }
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}, should be 'Debian' or 'Redhat'.")
    }
  }

}
