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

  if $::mariadb::install_manage {

    if $::mariadb::package_manage {

      case $::osfamily {
        'RedHat': {
          package { $::mariadb::package_name :
             ensure => $::mariadb::package_ensure,
          }
        }

        'Debian': {
          package { $::mariadb::package_name :
            ensure => $::mariadb::package_ensure,
          }
        }

        default: {
          fail("Unsupported OS Family '${::osfamily}', should be: 'Debian', 'Redhat'.")
        }
      }
    }

    if $::mariadb::disable_histfile {

      hpclib::print_config { $::mariadb::prof_histfile_file:
        style => 'linebyline',
        data  => $::mariadb::prof_histfile_options,
        mode  => 0644,
        owner => root,
      }

      file { $::mariadb::root_histfile_file:
        ensure => 'link',
        target => $::mariadb::root_histfile_target,
      }

    } else {

      # remove shell profile drop-in file
      file { $::mariadb::prof_histfile_file:
        ensure => 'absent',
      }

      # restore to flat empty file if symlink was previously deployed
      file { $::mariadb::root_histfile_file:
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
      }

    }
  }
}
