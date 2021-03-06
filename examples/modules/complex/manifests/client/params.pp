##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2016 EDF S.A.                                      #
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

class complex::client::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['complex-client-package']
  $packages_ensure = 'latest'
  $config_manage   = true
  $config_file     = '/etc/complex/client.conf'
  $user            = 'complex-client-user'

  # There is not any sane and secure possible default values for the following
  # params so it is better to not define them in this class.
  #   $password
}
