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

class pam::slurm::install inherits pam::slurm {

  if $::pam::slurm::packages_manage {

    case $::osfamily {

      'Debian': {
        file { $::pam::slurm::preseed:
          content => template('pam/libpam-slurm.preseed.erb'),
          mode    => '0644',
        }
        package { $::pam::slurm::packages:
          ensure       => $::pam::slurm::packages_ensure,
          responsefile => $::pam::slurm::preseed,
          require      => File[$::pam::slurm::preseed],
        }
      }

      default: {
        fail("Unsupported OS Family '${::osfamily}', should be: 'Debian'.")
      }

    }

  }

}
