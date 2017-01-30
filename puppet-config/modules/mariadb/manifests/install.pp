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

class mariadb::install {

  if $mariadb::package_manage {

    case $::osfamily {
      'RedHat': {
        package { $mariadb::package_name :
          ensure => $mariadb::package_ensure,
        }
      }

      'Debian': {
        file { $mariadb::mariadb_preseed_file :
          content => template($mariadb::mariadb_preseed_tmpl),
          mode    => '0400',
          owner   => 'root',
          backup  => false,
        }
        package { $mariadb::package_name :
          ensure       => $mariadb::package_ensure,
          responsefile => $mariadb::mariadb_preseed_file,
          require      => File[$mariadb::mariadb_preseed_file]
        }
      }

      default: {
        fail("Unsupported OS Family '${::osfamily}', should be: 'Debian', 'Redhat'.")
      }
    }
  }
}
