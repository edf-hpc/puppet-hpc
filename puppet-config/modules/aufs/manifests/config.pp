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

class aufs::config inherits aufs {
  # Mounts are defined but not activated, this is done by the service.
  #   x-systemd.requires-mount-for: systemctl start will refuse to start if mount for this
  #                                 path are not there
  $usr_bin_options = "noauto,br=${::aufs::overlay_dir}/usr/bin:${::aufs::squashfs_dir}/usr/bin:${::aufs::chroot_dir}/usr/bin,x-systemd.requires-mount-for=${::aufs::chroot_dir}"
  $usr_share_options = "noauto,br=${::aufs::overlay_dir}/usr/share:${::aufs::squashfs_dir}/usr/share:${::aufs::chroot_dir}/usr/share,x-systemd.requires-mount-for=${::aufs::chroot_dir}"

  mount { '/usr/bin':
    ensure  => present,
    device  => 'none',
    fstype  => 'aufs',
    options => $usr_bin_options,
    atboot  => false,
  }

  mount { '/usr/share':
    ensure  => present,
    device  => 'none',
    fstype  => 'aufs',
    options => $usr_share_options,
    atboot  => false,
  }

  exec { 'aufs_config_systemd_daemon_reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
    subscribe   => Mount[ '/usr/share', '/usr/bin' ]
  }
}
