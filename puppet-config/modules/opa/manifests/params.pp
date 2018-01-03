##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2018 EDF S.A.                                      #
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

class opa::params {

  case $::osfamily {
    'Debian': {
      $packages = [
        'kmod-ifs-kernel-updates',
        'hfi1-diagtools-sw',
        'hfi1-firmware',
        'hfi1-utils',
        'ibacm',
        'ibverbs-utils',
        'infiniband-diags',
        'libhfi1',
        'opa-address-resolution',
        'opa-scripts',
        'irqbalance',
        'rdmacm-utils'
      ]
      $kernel_modules = [
        'ib_ipoib',
      ]
      $irqbalance_config = '/etc/default/irqbalance'
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }

  $service_manage = true
  $service_name = 'opa'
  $service_enable = true
  $service_ensure = 'running'

  $irqbalance_service = 'irqbalance'
  $irqbalance_ensure  = running
  $irqbalance_enable  = true
  $irqbalance_options = {
    'enabled' => '1',
    'oneshot' => '0',
    'options' => '--hintpolicy=exact'
  }

  $modprobe_hfi1_manage = true
  $modprobe_hfi1_file = '/etc/modprobe.d/hfi1.conf'
  $modprobe_hfi1_options = [ 'options hfi1 krcvqs=4 sge_copy_mode=2 wss_threshold=70' ]

  $modprobe_ib_ipoib_manage = true
  $modprobe_ib_ipoib_file = '/etc/modprobe.d/ib_ipoib.conf'
  $modprobe_ib_ipoib_options = [ 'options ib_ipoib send_queue_size=8192 recv_queue_size=8192' ]

}
