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

class warewulf_nhc::params {

#### Module variables

  $packages_ensure = 'latest'
  $config_file     = '/etc/nhc/nhc.conf'
  $packages        = ['warewulf-nhc']
  $default_file    = '/etc/default/nhc'
#### Defaults values

  $default_options = {
    'HELPERDIR' => "'/usr/lib/warewulf-nhc/nhc'",
  }
  $install_devicequery = false
  $devicequery_src     = undef
  $devicequery_file    = '/usr/local/bin/deviceQuery'
}
