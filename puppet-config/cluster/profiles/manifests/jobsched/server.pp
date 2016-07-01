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

# Job scheduler server
#
# A generic configuration is defined in
# ``puppet-hpc/hieradata/common.yaml", in your own hiera files you could
# just redefine, the following values:
#
# ## Common
# ```
# slurm_primary_server:         "%{hiera('cluster_prefix')}%{::my_jobsched_server}1"
# slurm_secondary_server:       "%{hiera('cluster_prefix')}%{::my_jobsched_server}2"
# ```
#
# ## SlurmDBD
# ```
# slurmdbd_slurm_db_password: 'SLURM_PASSWORD_OVERRIDEME_IN_EYAML'
# slurmdbd_slurmro_db_password: 'SLURMRO_PASSWORD_OVERRIDEME_IN_EYAML'
# 
# slurmdbd::main_conf_options:
#   DbdHost:           "%{hiera('slurm_primary_server')}"
#   DbdBackupHost:     "%{hiera('slurm_secondary_server')}"
#   DbdPort:           '6819'
#   SlurmUser:         "%{hiera('slurm_user')}"        
#   DebugLevel:        '3'
#   AuthType:          'auth/munge' 
#   AuthInfo:          '/var/run/munge/munge.socket.2' 
#   LogFile:           "/var/log/slurm-llnl/slurmdbd.log"
#   PidFile:           '/var/run/slurm-llnl/slurmdbd.pid'
#   StorageType:       'accounting_storage/mysql'      
#   StorageHost:       'localhost'  
#   StorageUser:       'slurm'
#   StoragePass:       "%{hiera('slurmdbd_slurm_db_password')}"
#
# slurmdbd::dbd_conf_options:
#   db:
#     hosts:       'localhost'
#     user:        'debian-sys-maint' 
#     password:    "%{hiera('mariadb::mysql_root_pwd')}"
#   passwords:
#     slurm:       "%{hiera('slurmdbd_slurm_db_password')}"
#     slurmro:     "%{hiera('slurmdbd_slurmro_db_password')}" 
#   hosts:
#     controllers: "%{hiera('slurm_primary_server')},%{hiera('slurm_secondary_server')}"
#     admins:      "%{hiera('cluster_prefix')}admin1"
# ```
class profiles::jobsched::server {
  include ::slurmdbd
  include ::slurmctld
  include ::munge
  
  Class['::munge::service'] ->
  Class['::slurmdbd::service'] ->
  Class['::slurmctld::service']

  package{ [
    'slurm-llnl-generic-scripts-plugin',
  ]: }
}
