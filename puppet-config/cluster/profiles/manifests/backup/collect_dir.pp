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

# Collect directories periodically
#
# This configures a set of cron tasks that will collect directories from
# machines part of a list of profiles. The directories are synced locallly.
#
# ## Hiera
#  * ``profiles::backup::collect_dir::sources`` (``hiera_hash``) A hash
#      the sources to collect
class profiles::backup::collect_dir {
  $sources = hiera_hash('profiles::backup::collect_dir::sources')

  class { '::hpc_backup::collect_dir':
    sources => $sources,
  }
}
