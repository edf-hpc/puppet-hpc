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

#
class hpc_apt::config inherits hpc_apt {

  exec { 'add_foreign_arch':
    command => "/usr/bin/dpkg --add-architecture ${::hpc_apt::foreign_arch}",
    unless  => "/usr/bin/dpkg --print-foreign-architectures | grep ${::hpc_apt::foreign_arch}",
  }

  create_resources(apt::conf, $::hpc_apt::confs)
  create_resources(apt::source, $::hpc_apt::sources)

}
