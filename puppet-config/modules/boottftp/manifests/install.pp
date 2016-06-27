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

class boottftp::install inherits boottftp {

  ensure_resource('file',[$boottftp::config_dir_ftp],{'ensure' => 'directory'})

  $boot_files          = {
    "${boottftp::ipxe_efi_file}"    => {
      source                   => $boottftp::ipxe_efi_source,
      validate_cmd             => "test -d `dirname ${boottftp::ipxe_efi_file}`",
    },
    "${boottftp::ipxe_legacy_file}"    => {
      source                   => $boottftp::ipxe_legacy_source,
      validate_cmd             => "test -d `dirname ${boottftp::ipxe_legacy_file}`",
    },
  }

  create_resources(file,$boot_files)

}

