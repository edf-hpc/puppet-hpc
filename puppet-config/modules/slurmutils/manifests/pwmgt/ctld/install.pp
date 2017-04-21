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

class slurmutils::pwmgt::ctld::install inherits slurmutils::pwmgt::ctld {

  if $::slurmutils::pwmgt::ctld::install_manage {

    if $::slurmutils::pwmgt::ctld::packages_manage {
      package { $::slurmutils::pwmgt::ctld::packages:
        ensure => $::slurmutils::pwmgt::ctld::package_ensure,
      }
    }
  }

}
