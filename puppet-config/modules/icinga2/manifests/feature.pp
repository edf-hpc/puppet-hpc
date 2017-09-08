##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

define icinga2::feature () {

  exec { "enable-icinga2-feature-${name}":
    command => "${::icinga2::feature_enable_cmd} ${name}",
    creates => "${::icinga2::features_enable_dir}/${name}.conf",
  }

  # Feature configuration file is managed only if _features_conf hash has a key
  # for the feature.

  if dig($::icinga2::_features_conf, [$name]) {

    $_template = "icinga2/${name}.erb"
    $_feature_conf = "${::icinga2::features_avail_dir}/${name}.conf"

    file { $_feature_conf:
      content => template($_template),
      owner   => $::icinga2::user,
      group   => $::icinga2::user,
      mode    => '0644',
    }

  }

}
