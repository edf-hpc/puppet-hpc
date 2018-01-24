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

#
class gpfs::params {

  $install_manage  = true
  $packages_manage = true
  $service_manage  = true
  $config_manage   = true
  $ccr_enable      = false

  case $::osfamily {
    'Debian': {
      $_base_pkgs = [
        'gpfs.base',
        'gpfs.msg.en-us',
        'gpfs.gskit',
      ]
      case $::operatingsystemmajrelease {
        '8': {
          $_kernel_pkg = ['gpfs.gpl-3.16.0-4-amd64']
        }
        '7': {
          $_kernel_pkg = ['gpfs.gpl-3.2.0-4-amd64']
        }
        default: {
          fail("Unsupported OS major release '${::operatingsystemmajrelease}', should be: '6', '7'.")
        }
      }
    }
    'Redhat': {
      $_base_pkgs = [
        'gpfs.base',
        'gpfs.msg.en_US',
        'gpfs.ext',
        'gpfs.gskit',
        'gpfs.docs',
        'set_dma_latency',
      ]
      case $::operatingsystemmajrelease {
        '7': {
          $_kernel_pkg = ['gpfs.gplbin-3.10.0-123.el7.x86_64']
        }
        '6': {
          $_kernel_pkg = ['gpfs.gplbin-2.6.32-431.el6.x86_64']
        }
        default: {
          fail("Unsupported OS major release '${::operatingsystemmajrelease}', should be: '6', '7'.")
        }
      }
    }
    default: {
      fail("Unsupported OS Family '${::osfamily}', should be: 'Debian', 'Redhat'.")
    }
  }
  $packages        = concat($_base_pkgs, $_kernel_pkg)
  $packages_ensure = 'present'
  $lum_files       = {}
  $lum_hpc_files   = {}

  $config_file         = '/var/mmfs/gen/mmsdrfs'
  $config_src          = 'gpfs/mmsdrfs.enc'
  $ccr_nodes_file      = '/var/mmfs/ccr/ccr.nodes'
  $ccr_nodes_source    = ''
  $ccr_noauth_file     = '/var/mmfs/ccr/ccr.noauth'
  $ccr_noauth_source   = ''
  $ssh_private_key_src = undef
  $ssh_hosts           = '*'
  $ssl_keys            = {}
  $ssl_key_dir         = '/var/mmfs/ssl/stage'
  $file_mode           = '640'
  $cluster             = 'cluster'

  $service_name   = 'gpfs'
  $service_ensure = 'running'
  $service_enable = true

}
