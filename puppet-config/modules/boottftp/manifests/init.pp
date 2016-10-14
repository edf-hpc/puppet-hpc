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

# Installs ipxe boot files in a directory
#
# @param tftp_dir Directory whare to place ipxe binaries
# @param hpc_files Hash containing the ipxe binaries to install with their sources

class boottftp (
  $tftp_dir  = $::boottftp::params::tftp_dir,
  $hpc_files = $::boottftp::params::hpc_files,
) inherits boottftp::params {
  
  validate_string($tftp_dir)
  validate_hash($hpc_files)

  anchor { 'boottftp::begin': } ->
  class { '::boottftp::install': } ->
  anchor { 'boottftp::end': }

}
