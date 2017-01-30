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

class ceph::service inherits ceph {
  if $::ceph::service_enable {

  if has_key($::ceph::osd_config, $::hostname) {
    $osd = sprintf($::ceph::osd_service, $::ceph::osd_config[$::hostname]['id'])
    exec { $osd :
      command => "/bin/systemctl enable $osd",
      unless  => "/bin/systemctl is-enabled $osd",
    }
    service { $osd :
      ensure => $::ceph::service_ensure,
      enable => $::ceph::service_enable,
    }
  }

  if $::hostname in $::ceph::mds_config {
    exec { $::ceph::mds_service :
      command => "/bin/systemctl enable $::ceph::mds_service",
      unless  => "/bin/systemctl is-enabled $::ceph::mds_service",
    }
    service { $::ceph::mds_service :
      ensure => $::ceph::service_ensure,
      enable => $::ceph::service_enable,
    }
  }

  if $::hostname in $::ceph::mon_config {
    exec { $::ceph::mon_service :
      command => "/bin/systemctl enable $::ceph::mon_service",
      unless  => "/bin/systemctl is-enabled $::ceph::mon_service",
    }
    service { $::ceph::mon_service :
      ensure => $::ceph::service_ensure,
      enable => $::ceph::service_enable,
    }
  }

  if $::hostname in $::ceph::rgw_config {
    exec { $::ceph::rgw_service :
      command => "/bin/systemctl enable $::ceph::rgw_service",
      unless  => "/bin/systemctl is-enabled $::ceph::rgw_service",
    }
    service { $::ceph::rgw_service :
      ensure => $::ceph::service_ensure,
      enable => $::ceph::service_enable,
    }
  }

  service { $::ceph::services :
    ensure => $::ceph::service_ensure,
    enable => $::ceph::service_enable,
  }

  }
}
