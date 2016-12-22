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

  $fs_usr_bin = '/usr/bin'
  $fs_usr_share_apps = '/usr/share/applications'
  $fs_usr_share_pixmaps = '/usr/share/pixmaps'
  $fs_usr_share_doc = '/usr/share/man'
  $fs_usr_share_man = '/usr/share/doc'

  $fs_options = 'noauto,udba=none,x-systemd.requires-mount-for=${::aufs::chroot_dir},noatime,nodiratime,noxino'

  $usr_bin_options = "br=${::aufs::overlay_dir}${fs_usr_bin}:${::aufs::squashfs_dir}${fs_usr_bin}:${::aufs::chroot_dir}${fs_usr_bin}=rr,${fs_options}"
  $usr_share_apps_options = "br=${::aufs::overlay_dir}${fs_usr_share_apps}:${::aufs::squashfs_dir}${fs_usr_share_apps}:${::aufs::chroot_dir}${fs_usr_share_apps}=rr,${fs_options}"
  $usr_share_pixmaps_options = "br=${::aufs::overlay_dir}${fs_usr_share_pixmaps}:${::aufs::squashfs_dir}${fs_usr_share_pixmaps}:${::aufs::chroot_dir}${fs_usr_share_pixmaps}=rr,${fs_options}"
  $usr_share_doc_options = "br=${::aufs::overlay_dir}${fs_usr_share_doc}:${::aufs::squashfs_dir}${fs_usr_share_doc}:${::aufs::chroot_dir}${fs_usr_share_doc}=rr,${fs_options}"
  $usr_share_man_options = "br=${::aufs::overlay_dir}${fs_usr_share_man}:${::aufs::squashfs_dir}${fs_usr_share_man}:${::aufs::chroot_dir}${fs_usr_share_man}=rr,${fs_options}"

  mount { $fs_usr_bin :
    ensure  => present,
    device  => 'none',
    fstype  => 'aufs',
    options => $usr_bin_options,
    atboot  => false,
  }

  mount { $fs_usr_share_apps :
    ensure  => present,
    device  => 'none',
    fstype  => 'aufs',
    options => $usr_share_apps_options,
    atboot  => false,
  }

  mount { $fs_usr_share_pixmaps :
    ensure  => present,
    device  => 'none',
    fstype  => 'aufs',
    options => $usr_share_pixmaps_options,
    atboot  => false,
  }

  mount { $fs_usr_share_doc :
    ensure  => present,
    device  => 'none',
    fstype  => 'aufs',
    options => $usr_share_doc_options,
    atboot  => false,
  }

  mount { $fs_usr_share_man :
    ensure  => present,
    device  => 'none',
    fstype  => 'aufs',
    options => $usr_share_pixmaps_options,
    atboot  => false,
  }

  exec { 'aufs_config_systemd_daemon_reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
    subscribe   => Mount[ $fs_usr_bin, $fs_usr_share_apps, $fs_usr_share_man, $fs_usr_share_doc ]
  }
}
