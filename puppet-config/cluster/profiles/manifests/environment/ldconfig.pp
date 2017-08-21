##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016-2017 EDF S.A.                                      #
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

# Configuration for ldconfig
#
class profiles::environment::ldconfig {
  include ::ldconfig

  # If there is a gpfs mount as a trigger service, configure the ldconfig
  # service before starting GPFS. With GPFS the actual Mount resource
  # cannot be used because the gpfs service manipulates /etc/fstab
  # directly
  Class['::ldconfig'] -> Service <| title == 'gpfs' |>
}
