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

#
class gpfs::params {

  # File and directory modes
  $cl_dir_mode        = '755'
  $cl_file_mode       = '640'

  # Password to decrypt encrypted files
  $cl_decrypt_passwd  = 'password'

  # Cluster name
  $cluster = 'cluster'

  # Packages to install
  # It is assumed that license files are managed with a
  # special package : gpfs.lum for both Debian and Red Hat
  case $::osfamily {
    'Debian': {
      $cl_base = [
        'gpfs.base',
        'gpfs.msg.en-us',
        'gpfs.lum',
        'gpfs.gskit',
      ]
      case $::operatingsystemmajrelease {
        '8': {
          $cl_kernel = ['gpfs.gpl-3.16.0-4-amd64']
        }
        '7': {
          $cl_kernel = ['gpfs.gpl-3.2.0-4-amd64']
        }
        default: {
          fail("Unsupported OS major release '${::operatingsystemmajrelease}', should be: '6', '7'.")
        }
      }
      $sr_packages        = []
      $sr_packages_ensure = ''
    }
    'Redhat': {
      $cl_base = [
        'gpfs.base',
        'gpfs.msg.en_US',
        'gpfs.ext',
        'gpfs.gskit',
        'gpfs.lum',
      ]
      case $::operatingsystemmajrelease {
        '7': {
          $cl_kernel = ['gpfs.gplbin-3.10.0-123.el7.x86_64']
        }
        '6': {
          $cl_kernel = ['gpfs.gplbin-2.6.32-431.el6.x86_64']
        }
        default: {
          fail("Unsupported OS major release '${::operatingsystemmajrelease}', should be: '6', '7'.")
        }
      }
      $sr_packages        = ['gpfs.docs','set_dma_latency']
      $sr_packages_ensure = 'present'
    }
    default: {
      fail("Unsupported OS Family '${::osfamily}', should be: 'Debian', 'Redhat'.")
    }
  }
  $cl_packages        = [$cl_base, $cl_kernel]
  $cl_packages_ensure = 'present'
  $cl_config_dir      = [
    '/var/mmfs',
    '/var/mmfs/gen',
    '/var/lock',
    '/var/lock/subsys',
    '/usr/lpp',
    '/usr/lpp/mmfs',
    '/usr/lpp/mmfs/lib',
    '/var/mmfs/ssl',
    '/var/mmfs/ssl/stage',
  ]
  $cl_config          = '/var/mmfs/gen/mmsdrfs'
  $cl_config_src      = 'gpfs/mmsdrfs.enc'
  $cl_key             = '/var/mmfs/ssl/stage/genkeyData1'
  $cl_key_src         = 'gpfs/genkeyData1.enc'


  $service                  = 'gpfs'
  $service_ensure  = running
  $service_enable  = true
  $service_override_options = {
    'Service' => {
      'ExecStartPre' => '/bin/true',
      'Restart'      => 'on-failure',
      'RestartSec'   => '5',
    },
  }

}
