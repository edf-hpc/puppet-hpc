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

# Export a local directory with NFS
#
# @param exportdir    Directory to export
# @param host         Hosts authorized to connect to this export
# @param options      Exports options (see `exports(5)`)
# @param exports_file file where the export is defined (default: `/etc/exports`)
define nfs::server::export (
  $exportdir,
  $host         = '*',
  $options      = 'ro,sync',
  $exports_file = $::nfs::server::exports_file,
){
  require ::nfs::server

  if $options {
    $content = "${exportdir}    ${host}(${options})\n"
  }
  else {
    $content = "${exportdir}    ${host}\n"
  }

  concat::fragment { "${exportdir}_on_${host}":
    ensure  => 'present',
    content => $content,
    target  => $exports_file,
  }

}
