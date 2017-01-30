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

class aptcacherng::params {
  #### Module variables
  $packages        = ['apt-cacher-ng']
  $packages_ensure = installed
  $service         = 'apt-cacher-ng'
  $service_ensure  = running
  $service_enable  = true
  $config_file     = '/etc/apt-cacher-ng/acng.conf'

  #### Default values
  $config_options_defaults = {
    'CacheDir'     => '/var/cache/apt-cacher-ng',
    'LogDir'       => '/var/log/apt-cacher-ng',
    'Port'         => '3142',
    'Remap-debrep' => 'file:deb_mirror*.gz /debian ; file:backends_debian',
    'Remap-uburep' => 'file:ubuntu_mirrors /ubuntu ; file:backends_ubuntu',
    'Remap-debvol' => 'file:debvol_mirror*.gz /debian-volatile ; file:backends_debvol',
    'Remap-fedora' => 'file:fedora_mirrors',
    'Remap-epel'   => 'file:epel_mirrors',
    'Remap-slrep'  => 'file:sl_mirrors',
    'ReportPage'   => 'acng-report.html',
    'ExTreshold'   => '4',
    'LocalDirs'    => 'acng-doc /usr/share/doc/apt-cacher-ng',
  }
}
