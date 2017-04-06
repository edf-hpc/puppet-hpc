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

class infiniband::service inherits infiniband {

  # Install systemd services on supported OS.
  if $::operatingsystem == 'Debian' and $::operatingsystemmajrelease >= '8' {

    hpclib::systemd_tmpfile { $::infiniband::systemd_tmpfile :
      target => $::infiniband::systemd_tmpfile,
      config => $::infiniband::systemd_tmpfile_options,
    }
  }
  else {
    notice('Unsupported service provider for class network::service.')
  }

}
