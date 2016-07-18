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

class openssh::client::keys inherits openssh::client {

  ::openssh::client::identity {$::openssh::client::root_key_file:
    key_enc        => $::openssh::client::root_key_enc,
    config_file    => $::openssh::client::root_config_file,
    host           => '*',
    decrypt_passwd => $openssh::client::decrypt_passwd,
  }

}
