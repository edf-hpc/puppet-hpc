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

# Setup a virtualization physical host
#
# Will install a libvirt daemon with kvm. No other configuration (hosts,
# networks, pools, volumes...) done by default.
#
# ## Hiera
# * profiles::virt::networks (`hiera_hash`) Resource definitions for libvirt::network
# * profiles::virt::pools (`hiera_hash`) Resource definitions for libvirt::pool
# * profiles::virt::secrets (`hiera_hash`) Resource definitions for libvirt::secret
class profiles::virt::host {
  include '::libvirt'

  $networks = hiera_hash('profiles::virt::networks')
  $pools = hiera_hash('profiles::virt::pools')
  $secrets = hiera_hash('profiles::virt::secrets')

  create_resources(libvirt::network, $networks)
  create_resources(libvirt::pool, $pools)
  create_resources(libvirt::secret, $secrets)

}
