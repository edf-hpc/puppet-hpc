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

class vtune::params {

#### Module variables

  $packages_ensure = 'latest'
  $packages        = ['sep-modules','sep-modules-scripts']
  $default_file    = '/etc/default/sep-scripts'

#### Defaults values
  $default_options = {
    'DRIVER_DIRECTORY' => '/lib/modules/3.16.0-4-amd64/extra',
    'DRIVER_GROUP'     => 'vtune-users',
    'DRIVER_PERMS'     => '660',
  }

}
