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

# Export a local directory with NFS
#
# @param export    Directory to export
# @param clients   Array of hosts/options pairs
# @param exports_file file where the export is defined (default: `/etc/exports`)
define nfs::server::export (
  $export,
  $clients      = $::nfs::server::params::clients,
  $exports_file = $::nfs::server::exports_file,
){

  validate_absolute_path($export)
  validate_array($clients)
  validate_absolute_path($exports_file)

  concat::fragment { "${export}_on_${$name}":
    ensure  => 'present',
    content => template('nfs/export_fragment.erb'),
    target  => $exports_file,
  }

}
