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

#
class boottftp::params {

  $config_dir                      = '/public/ipxe'
  $config_dir_source               = '/path/to/sources'

  # Files that can be downloaded by FTP
  $config_dir_ftp                  = "${config_dir}/tftp"
  $ipxe_efi_source                 = "${config_dir_source}/ipxe.efi"
  $ipxe_legacy_source              = "${config_dir_source}/ipxe.legacy"

}
