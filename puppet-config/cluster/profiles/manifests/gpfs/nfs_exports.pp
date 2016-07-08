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

# GPFS -  CNFS server
#
# ## Hiera
# * `gpfs::nfs_to_export` (`hiera_hash`)
class profiles::gpfs::nfs_exports {

  # Hiera lookups
  $to_export = hiera_hash('gpfs::nfs_to_export')

  # Install gpfs client
  class { '::gpfs::client': }

  # Install gpfs server
  class { '::gpfs::server': }

  # Set up multipath
  class { '::multipath': }

  # Mount all the specified directories
  create_resources('::gpfs::server::export', $to_export)

}
