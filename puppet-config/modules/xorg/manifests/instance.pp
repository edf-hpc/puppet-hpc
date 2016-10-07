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

# Sets up an instance
#
# An xorg instance is defined with an ID (usually starting at 0), each
# instance will have an instanciated unit instance and a configuration
# file.
# 
# ## Drivers
#
# There is 3 drivers modes: 
# - `auto`, lets Xorg do what it wants
# - `custom`, provide an xorg.conf file
# - `nvidia`, setting up an nvidia configuration
#
# ## PCI Bus ID
# 
# With nvidia card it is necessary to provide the PCI bus ID of the card
# on the node.
# 
# You can find it with `lspci |grep -i nv`. Be carefull, lspci returns
# the PCI Bus ID as an hexadecimal ID. The xorg configuration wants a 
# decimal value (`10` -> `16`)
#
# Leaving the default (`auto`) remove the explicit setting from the 
# configuration
# 
# @params display_id     Integer ID for the instance, use the title of the
#                        resource by default
# @params bus_id         PCI Bus ID of the target GPU (default: `auto`)
# @params driver         `auto`, `custom` or `nvidia`
# @params config_content Direct content of the config file 
# @params config_source  A puppet source of the config file
define xorg::instance (
  $display_id     = $title,
  $bus_id         = 'auto',
  $driver         = 'auto',
  $config_content = undef,
  $config_source  = undef,
  $service_ensure = 'running',
  $service_enable = true,
) {
  validate_integer($display_id)

  $config_file = "/etc/X11/xorg${display_id}.conf"

  $service = "${::xorg::service}${display_id}"

  case $driver {
    'auto': {
      $config_ensure  = 'absent'
      $_config_content = undef
    }
    'custom': {
      # A configuration is required with custom driver, then fail is undef
      if $config_content == undef and
        $config_source == undef {
        fail('For driver custom, you should provide a config_content or a config_source')
      }

      $config_ensure  = 'present'
      $_config_content = $config_content
    }
    'nvidia': {
      $config_ensure = 'present'
      # Default to the module template if none is provided
      if $config_content == undef and $config_source == undef {
        $_config_content = template('xorg/xorg.nvidia.conf.erb')
      } else {
        $_config_content = $config_content
      }
    }
    default: {
      fail("Unsupported xorg driver '${driver}', should be: 'auto', 'custom' or 'nvidia'.")
    }
  }

  file { $config_file:
    ensure  => $config_ensure,
    content => $_config_content,
    source  => $config_source,
    require => Class['xorg::config'],
  }

  service { $service:
    ensure    => $service_ensure,
    enable    => $service_enable,
    subscribe => File[$config_file],
  }

}
