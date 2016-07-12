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

class nfs::server::params {

  # Module variables
  $exports_file    = '/etc/exports'
  $packages_ensure = 'present'
  $service_ensure  = 'running'
  case $::osfamily {
    'Debian': {
      $packages = ['nfs-kernel-server']
      $service   = 'nfs-kernel-server'
    }
    'Redhat': {
      # Same as ::nfs::packages
      $packages = []
      case $::operatingsystemmajrelease {
        '7': {
          $service = 'nfs-server'
        }
        default: {
          $service = 'nfs'
        }
      }
    }
    default: {
      fail ("Unsupported OS Family: ${::osfamily}")
    }
  }

}

