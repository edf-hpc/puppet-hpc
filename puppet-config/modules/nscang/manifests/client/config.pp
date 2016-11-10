##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class nscang::client::config inherits nscang::client {

  if $::nscang::client::config_manage {

    file { $::nscang::client::config_file:
      content => template('nscang/client.erb'),
      owner   => $::nscang::client::user,
      group   => $::nscang::client::user,
      mode    => 0600,
    }

  }
}
