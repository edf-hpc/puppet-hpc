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

# Setup a local Xorg server and let it auto-confgure
class profiles::xorg::auto {
  # Make sure the xorg class is realized after the base packages are installed.
  # The base module installs the scibian-hpc meta-packages which are supposed to
  # depend on all the required packages for xorg to run on nvidia modules.
  Package <| tag == 'base' |> ->
  class { '::xorg':}

  $instances = hiera_hash('profiles::xorg::instances')
  create_resources(xorg::instance, $instances)
}
