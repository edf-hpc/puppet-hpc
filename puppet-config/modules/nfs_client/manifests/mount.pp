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

define nfs_client::mount (
  $server,
  $exportdir,
  $mountpoint,
  $options,
  $ensure   = 'mounted',
  $atboot   = true,
  $remounts = false,  
  $pass     = 2,
  $dump     = 0,
){

  if $ensure == 'mounted' {
    # Make sure the mount point exists
    exec {"creating_${mountpoint}":
      command => "mkdir -p ${mountpoint}",
      unless  => "test -d ${mountpoint}",
      path    => $::path,
    }
  
    file { $mountpoint:
      ensure  => 'directory',
      require => Exec["creating_${mountpoint}"],
    }
  }

  # Mount the device
  mount {"${mountpoint}":
    ensure        => $ensure,
    device        => "${server}:${exportdir}",
    fstype        => 'nfs',
    atboot        => $atboot,
    options       => $options, 
    pass          => $pass,
    remounts      => $remounts,
    dump          => $dump,
  }

} 
