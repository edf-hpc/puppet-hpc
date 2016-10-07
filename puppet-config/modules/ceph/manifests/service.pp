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

class ceph::service inherits ceph {
  if $::ceph::service_enable {

  if has_key($::ceph::osd_config, $::hostname) {
    $osd = sprintf($::ceph::osd_service, $::ceph::osd_config[$::hostname]['id'])
    $b_osd = basename($osd)
    hpclib::systemd_meta_service { $b_osd :
      service => $osd,
      source  => $::ceph::osd_meta_service,
      ensure  => $::ceph::service_ensure,
      enable => $::ceph::service_enable,
    }
  }

  if $::hostname in $::ceph::mds_config {
    $b_mds = basename($::ceph::mds_service)
    hpclib::systemd_meta_service { $b_mds :
      service => $::ceph::mds_service,
      source  => $::ceph::mds_meta_service,
      ensure  => $::ceph::service_ensure,
      enable => $::ceph::service_enable,
    }
  }

  if $::hostname in $::ceph::mon_config {
    $b_mon = basename($::ceph::mon_service)
    hpclib::systemd_meta_service { $b_mon :
      service => $::ceph::mon_service,
      source  => $::ceph::mon_meta_service,
      ensure  => $::ceph::service_ensure,
      enable => $::ceph::service_enable,
    }
  }

  if $::hostname in $::ceph::rgw_config {
    $b_rgw = basename($::ceph::rgw_service)
    hpclib::systemd_meta_service { $b_rgw :
      service => $::ceph::rgw_service,
      source  => $::ceph::rgw_meta_service,
      ensure  => $::ceph::service_ensure,
      enable => $::ceph::service_enable,
    }
  }

  service { $::ceph::services :
    ensure => $::ceph::service_ensure,
    enable => $::ceph::service_enable,
  }

  }
}
