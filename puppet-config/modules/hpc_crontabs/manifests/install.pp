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

class hpc_crontabs::install inherits hpc_crontabs {

  # ensure destination directory exists
  ensure_resource(file,
                  $crontabs_dir_destination,
                  { ensure => 'directory' })

  # then create source symlink
  file { $crontabs_dir_source :
      ensure  => 'link',
      target  => $crontabs_dir_destination,
      replace => true,
      force   => true,
      require => File[$crontabs_dir_destination],
  }

}
