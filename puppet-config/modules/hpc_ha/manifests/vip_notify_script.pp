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

# A script to call when a VIP changes state
#
# `source` and `content` cannot both be undefined.
#
# @param vip_name Name of the `hpc_ha:vip` resource
# @param part The part the notify script is run (default: 'common')
# @param ensure Target state of the script file (default: 'present')
# @param source `hpc_source_file` location for the script file
# @param content Content of the script file, takes precedence over `source`
#           if both are provided.
define hpc_ha::vip_notify_script (
  $vip_name,
  $part    = 'common',
  $ensure  = present,
  $source  = undef,
  $content = undef,
) {
  validate_string($vip_name)
  validate_string($part)

  # clean-up vip name
  $_vip_name = regsubst($vip_name, '[:\/\n]', '')

  # check part value
  case $part {
    'common','master','backup','stop','fault': {
      debug("part value ${part} is valid")
    }
    default: {
      fail("part value ${part} is not valid")
    }
  }

  if $content {
    $real_content = $content
  }
  else {
    $real_content = hpc_source_file($source)
  }

  $prefix = getparam(Hpc_ha::Vip[$vip_name], 'prefix')
  $up_name = upcase($vip_name)
  $up_prefix = upcase($prefix)
  $vrrp_instance_id = "VI_${up_prefix}${up_name}"

  if $part == 'common' {
    $_part_dir = 'notify'
  } else {
    $_part_dir = "notify_${part}"
  }

  if $source {
    # The script name appending the real filename is the basename of the source
    # URL where dots (.) are replaced by dash (-) since run-part ignores files
    # containing dots.
    $_script_name = regsubst(basename($source), '\.', '-')
  } else {
    $_script_name = 'common'
  }

  file { "/etc/hpc_ha/${vrrp_instance_id}/${_part_dir}/vserv_${_vip_name}_notify_${_script_name}":
    ensure  => $ensure,
    content => $real_content,
    mode    => '0700',
    require => Hpc_ha::Vip[$vip_name],
  }

}
