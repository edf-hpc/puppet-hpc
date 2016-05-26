#!/bin/bash 
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

PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"
SA=/usr/sbin/slapadd
CFGROOT=/etc/ldap
CERTDIR=${CFGROOT}/certificates
CFGDIR=${CFGROOT}/slapd.d
CALDIR=/var/lib/calibre/slapdcfg
FLOCK=${CALDIR}/replica.run
DBDIR=/var/lib/ldap
LDIF_FILE=${CALDIR}/config_replica.ldif
CONFIRM=""

###################################################################
print_error () {
  case ${1} in
    1)
		  echo -e "\e[00;31m Cannot find any ldif file in ${CALDIR}. \e[00m"
	    ;;
	  2)
		  echo -e "\e[00;33m WARNING: replication is yet configured. To recreate the configuration remove this file: ${FLOCK}. \e[00m"
	    ;;
	esac
	
	exit ${1}
}

check_files () {
  if [ -r "${LDIF_FILE}" ]
  then
	  echo "You are about to configure a new replica for ldap directory. Old Configuration will be wipped."
  else
	  print_error 1
  fi
  echo "Please type YES followed by [ENTER] to confirm you want to erase current configuration."
  read CONFIRM
}

set_certs_owner () {
	for file in `ls ${CERTDIR}`
	do
		chown openldap:openldap ${CERTDIR}/${file}
	done
}

cleaning () {
  systemctl stop slapd
  for directory in ${CFGDIR} ${DBDIR}
  do
    if [ -d `echo ${directory}` ]
    then
      rm -rf ${directory}
			mkdir ${directory}
    fi
  done
	sleep 1
}

set_config () {
	${SA} -b cn=config -F ${CFGDIR} -l "${LDIF_FILE}"
	chown -R openldap:openldap ${DBDIR}
  chown -R openldap:openldap ${CFGDIR}
	touch ${FLOCK}
	systemctl start slapd	
}

if [ -e ${FLOCK} ]
then
	print_error 2
else
	check_files
	if [ ${CONFIRM} == "YES" ]
	then
	  cleaning
		set_certs_owner
	  set_config
	fi
fi
