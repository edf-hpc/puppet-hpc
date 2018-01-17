##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2018 EDF S.A.                                      #
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

#
class gpfs::install inherits gpfs {

  if $::gpfs::install_manage {

    create_resources(file, $::gpfs::lum_files)
    create_resources( hpclib::hpc_file,
                      $::gpfs::lum_hpc_files,
                      { require => File[keys($::gpfs::lum_files)] })

    if $::gpfs::packages_manage {
      package { $::gpfs::packages :
        ensure  => $::gpfs::packages_ensure,
        require => File[keys($::gpfs::lum_hpc_files)],
      }
    }
  }

}
