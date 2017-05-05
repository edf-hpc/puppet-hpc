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

class consul::params {

  $packages        = ['consul',
                      'consult']
  $packages_ensure = 'latest'
  $packages_manage = true
  $services        = ['consul']
  $services_ensure = 'running'
  $services_enable = true
  $services_manage = true
  $config_manage   = true

  $system_user     = 'consul'
  $conf_dir        = '/etc/consul.d'
  $data_dir        = '/var/lib/consul'

  $mode            = 'server'
  $domain          = 'virtual.'
  $datacenter      = 'local'
  $binding         = '127.0.0.1'
  $subservices     = undef
  $nodes           = []
  $bootstrap       = 1

}
