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

# Mount an NFS export after creating the mount point
#
# @param server     NFS server host
# @param exportdir  Directory to mount on the server
# @param mountpoint Local mount point
# @param options    Mount options (see `mount(8)` and `nfs(5)`)
# @param ensure     State of the mount
# @param atboot     File system should be mounted during boot
# @param remounts   Remount the file system if options changes
define nfs::client::mount (
  $server,
  $exportdir,
  $mountpoint,
  $options,
  $ensure   = 'mounted',
  $atboot   = true,
  $remounts = false,
){

  if $ensure == 'mounted' {
    # Make sure the mount point exists
    exec { "creating_${mountpoint}":
      command => "mkdir -p ${mountpoint}",
      unless  => "test -d ${mountpoint}",
      path    => $::path,
    }

    file { $mountpoint:
      ensure  => 'directory',
      require => Exec["creating_${mountpoint}"],
    }

    $mount_require = [File[$mountpoint], Class['::nfs']]
  } else {
    $mount_require = undef
  }

  # Mount the device
  #  Dump and pass should always be 0 for NFS
  mount { $mountpoint:
    ensure   => $ensure,
    device   => "${server}:${exportdir}",
    fstype   => 'nfs',
    atboot   => $atboot,
    options  => $options,
    pass     => 0,
    remounts => $remounts,
    dump     => 0,
    require  => $mount_require,
  }

}
