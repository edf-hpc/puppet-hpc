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

class ddnsrp::install inherits ddnsrp {

  if $::ddnsrp::install_manage {

    if $::ddnsrp::packages_manage {

      package { $::ddnsrp::packages:
        ensure => $::ddnsrp::packages_ensure,
      }

    }

    if $::ddnsrp::init_src != undef {
      hpclib::hpc_file { $::ddnsrp::init_file :
        source => $::ddnsrp::init_src,
        mode   => '0755',
        owner  => 'root',
        group  => 'root',
        require => Package[$::ddnsrp::packages],
      }
    }
  }

}
