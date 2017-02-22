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

class nfs::params {
  # Module variables
  $packages_ensure = 'present'
  $service_ensure  = 'running'
  case $::osfamily {
    'Debian': {
      $packages = ['nfs-common']
      $service  = 'nfs-common'
    }
    'Redhat': {
      $packages = ['nfs-utils.x86_64']
      $service  = 'nfs'
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }

  $idmapd_file = '/etc/idmapd.conf'
  $idmapd_options_defaults = {
    'General' => {
      'Verbosity' => {
        'comment'   => 'Verbosity',
        'value'     => '0',
      },
      'Pipefs-Directory' => {
        'comment'   => 'Piperfs-Directory',
        'value'     => '/run/rpc_pipefs',
      },
    },
    'Mapping' => {
      'Nobody-User' => {
        'comment'   => 'Nobody-User',
        'value'     => 'nobody',
      },
      'Nobody-Group' => {
        'comment'   => 'Nobody-Group',
        'value'     => 'nogroup',
      },
    },
  }

  $default_file = '/etc/default/nfs-common'
  $default_options_defaults = {
    'NEED_STATD'  => '',
    'STATDOPTS'   => '',
    'NEED_IDMAPD' => 'yes',
    'NEED_GSSD'   => '',
  }

  $enable_gssd = false

}
