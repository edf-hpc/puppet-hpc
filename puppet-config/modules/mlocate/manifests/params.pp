##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2017 EDF S.A.                                           #
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

class mlocate::params {
  $packages_ensure = 'installed'
  $packages = ['mlocate']
  $config_file = '/etc/updatedb.conf'
  $prunefs = [
    'NFS',
    'nfs',
    'nfs4',
    'rpc_pipefs',
    'afs',
    'binfmt_misc',
    'proc',
    'smbfs',
    'autofs',
    'iso9660',
    'ncpfs',
    'coda',
    'devpts',
    'ftpfs',
    'devfs',
    'mfs',
    'shfs',
    'sysfs',
    'cifs',
    'lustre',
    'tmpfs',
    'usbfs',
    'udf',
    'fuse.glusterfs',
    'fuse.sshfs',
    'curlftpfs',
    'gpfs',
  ]
  $prunepaths = [
    '/tmp',
    '/var/spool',
    '/media',
  ]
  $extra_prunefs = []
  $extra_prunepaths = []
  $prune_bind_mounts = true
}
