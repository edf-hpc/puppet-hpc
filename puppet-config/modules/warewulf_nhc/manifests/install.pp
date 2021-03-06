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

class warewulf_nhc::install inherits warewulf_nhc {

  package { $::warewulf_nhc::packages:
    ensure => $::warewulf_nhc::packages_ensure,
  }

  if $::warewulf_nhc::install_devicequery {
    file { $::warewulf_nhc::devicequery_file:
      content => hpc_source_file($::warewulf_nhc::devicequery_src),
      mode    => '0755',
    }
  }

}
