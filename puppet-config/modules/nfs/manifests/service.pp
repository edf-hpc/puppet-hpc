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

class nfs::service inherits nfs {

  service { $::nfs::service:
    ensure    => $::nfs::service_ensure,
  }

  if $::nfs::disable_rpcbind {
    service { $::nfs::service_rpcbind:
      ensure => stopped,
      enable => false,
    }
  }

  # This is a workaround for what is (arguably) a bug in nfs-common sysv
  # initscript on Debian.
  # The default value for NEED_STATD in nfs-commob is yes. When setting it to
  # 'no' and restarting nfs-common service (ie. the sequence run by default with
  # this module on a fresh system), the initscript does not check if the statd
  # daemon was previously launched and does not even try to stop it. This is
  # particularly annoying on diskless nodes where only one Puppet run must
  # result on the targeted configuration. To workaround this, if NEED_STATD is
  # no and the rpc.statd is running, the daemon is explicitely stopped.
  if $::osfamily == 'Debian' and
     dig($::nfs::_default_options, ['NEED_STATD']) == 'no' {
    exec { 'stop-rpcbind':
      command => '/sbin/start-stop-daemon --stop --name rpc.statd',
      onlyif => '/usr/bin/pgrep rpc.statd'
    }
  }

}
