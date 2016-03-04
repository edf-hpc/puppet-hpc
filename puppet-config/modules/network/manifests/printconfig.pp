##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2015 EDF S.A.                                      #
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

define network::printconfig ($target = 'eth0') {

  if $::osfamily == 'Debian' {
    $filename = $network::commons::cfg
    $tplname  = 'network/interfaces.erb'
    $execmd   = '/bin/systemctl reload networking'
    $execname = 'reload_net'
  }
  elsif $::osfamily == 'Redhat' {
    $filename = "${network::commons::cfg}-${target}"
    $tplname  = 'network/ifcfg.erb'
    $execmd   = "/bin/systemctl stop ifup@${target}.service && /bin/systemctl start ifup@${target}.service"
    $execname = "restart_${target}"
  }

  file { $filename :
    content    => template($tplname),
  }

  exec { $execname:
    command     => $execmd,
    subscribe   => File[$filename],
    refreshonly => true,
  }
}

