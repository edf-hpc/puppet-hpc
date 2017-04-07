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

class opa::params {

  case $::osfamily {
    'Debian': {
      $packages = [
        'compat-rdma-modules-3.16.0-4-amd64',
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
        'rdmacm-utils',
        'rdma'
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

  $irqbalance_service = 'irqbalance'
  $irqbalance_ensure  = running
  $irqbalance_enable  = true
  $irqbalance_options = {
    'enabled' => '1',
    'oneshot' => '0',
    'options' => '--hintpolicy=exact'
  }

}
