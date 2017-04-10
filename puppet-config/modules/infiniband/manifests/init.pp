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

# Configure Infiniband
#
# @param packages List of packages for the Infiniband stack
# @param ib_file Path of the infiniband stack config file
# @param ib_options Key/Value hash with the content of `ib_file`
# @param systemd_tmpfile tmpfile config file path
# @param systemd_tmpfile_options tmpfile config content as an array of line
# @param mlx4load Load the `mlx4` driver, 'yes'` or 'no' (default: 'yes')
class infiniband (
  $packages                = $::infiniband::params::packages,
  $ib_file                 = $::infiniband::params::ib_file,
  $ib_options              = {},
  $systemd_tmpfile         = $::infiniband::params::systemd_tmpfile,
  $systemd_tmpfile_options = $::infiniband::params::systemd_tmpfile_options,
  $mlx4load                = $::infiniband::params::mlx4load,
) inherits infiniband::params {

  validate_array($packages)
  validate_absolute_path($ib_file)
  validate_hash($ib_options)
  validate_absolute_path($systemd_tmpfile)
  validate_array($systemd_tmpfile_options)
  validate_string($mlx4load)

  # OpenIB options
  $mlx_options = {
    'mlx4_load'    => $mlx4load,
    'mlx4_en_load' => $mlx4load,
  }
  $_ib_options = merge(
    $::infiniband::params::ib_options_defaults,
    $ib_options,
    $mlx_options
  )

  anchor { 'infiniband::begin': } ->
  class { '::infiniband::install': } ->
  class { '::infiniband::config': } ~>
  anchor { 'infiniband::end': }

}
