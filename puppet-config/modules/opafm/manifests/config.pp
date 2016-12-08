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

class opafm::config inherits opafm {
  if $::opafm::config_source {
    hpclib::hpc_file { $::opafm::config_file:
      ensure => present,
      source => $::opafm::config_source,
    }
  } else {
    $fe_enable      = $::opafm::fe_enable
    $fe_sslsecurity = $::opafm::fe_sslsecurity
    file { $::opafm::config_file:
      ensure  => present,
      content => template('opafm/opafm.xml.erb'),
    }
  }

  if $::opafm::switch_source {
    hpclib::hpc_file { $::opafm::switch_file :
      source => $::opafm::switch_source,
    }
  }
}

