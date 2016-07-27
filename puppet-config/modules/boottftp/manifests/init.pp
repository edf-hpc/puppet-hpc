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

# Installs ipxe boot files in a directory
#
# @param config_dir_ftp     Target directory for boot files
# @param ipxe_efi_source    Source URL for IPXE EFI file
# @param ipxe_legacy_source Source URL for IPXE legacy (non EFI) file
class boottftp (

  $config_dir_ftp                  = $ipxe::params::config_dir_ftp,
  $ipxe_efi_source                 = $ipxe::params::ipxe_efi_source,
  $ipxe_legacy_source              = $ipxe::params::ipxe_legacy_source,

) inherits boottftp::params {

  validate_absolute_path($config_dir_ftp)
  validate_string($ipxe_efi_source)
  validate_string($ipxe_legacy_source)

  $ipxe_efi_file                   = "${config_dir_ftp}/ipxe.efi"
  $ipxe_legacy_file                = "${config_dir_ftp}/ipxe.legacy"

  anchor { 'boottftp::begin': } ->
  class { '::boottftp::install': } ->
  anchor { 'boottftp::end': }

}
