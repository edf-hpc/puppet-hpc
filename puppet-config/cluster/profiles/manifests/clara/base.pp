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

# Setup clara
#
# ## Hiera
# * `profiles::clara::repos`
#
# ## Autolookups
# * `clara::apt_ssl_cert_source`
# * `clara::apt_ssl_cert_file`
# * `clara::apt_ssl_key_source`
# * `clara::apt_ssl_key_file`
# * `clara::decrypt_password`

class profiles::clara::base {

  class { '::clara':
    repos_options => hiera_hash('profiles::clara::repos'),
  }

}
