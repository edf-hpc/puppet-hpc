#!/bin/bash 
##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2015 EDF S.A.                                      #
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

MYROOT=$(dirname $(readlink -f ${0}))
MODDIR=${MODDIR:-${MYROOT}/modules}
MODULES=$(ls ${MODDIR})

print_error () {
	case ${1} in
  	1)
    	echo -e "\e[00;33m Usage: ${0} [ --syntax | --lint ] (module) \e[00m" 
		;;
	esac
	exit ${1}
}

ctrl_manif () {
  
	[ ! -z ${1} ] || return 1

	INV=${1}
	if [ ! -z ${2} ]
  	then
		MODULES=${2}
	fi


	for dir in ${MODULES}
	do
		if [ -d ${MODDIR}/${dir}/manifests ]
		then
			MANIFESTS=$(find ${MODDIR}/${dir}/manifests -type f -name "*.pp")
		else
			MANIFESTS=""
		fi

		if [ -d ${MODDIR}/${dir}/templates ]
		then
			TEMPLATES=$(ls ${MODDIR}/${dir}/templates)
		else
			TEMPLATES=""
		fi

		if [[ ! -z ${MANIFESTS} ]]
		then
			echo "MODULE = ${dir}"
			for manif in ${MANIFESTS}
			do
				if [[ ${INV} == "--syntax" ]]
				then
					puppet parser validate ${manif} && echo "${manif} = Syntax OK"
				else
					sed -i 's/[ \t]*$//' ${manif}
					sed -i --posix -e 's/\t/  /g' ${manif}
					/usr/bin/puppet-lint \
            --no-80chars-check \
            --no-class_inherits_from_params_class-check \
            --log-format '%{path}" "%{KIND}": "%{message}" on line "%{line}' \
            ${manif}
				fi
			done
		fi

		if [[ ! -z ${TEMPLATES} && ${INV} == "--syntax" ]]
		then
			for temp in ${TEMPLATES}
			do
				echo "${temp} = $(erb -P -x -T '-' ${MODDIR}/${dir}/templates/${temp} | ruby -c)"
			done
		fi
		echo ""
	done
}


case ${1} in

	--syntax | --lint) 
		if [ ${#} -eq 2 ]
		then
			ctrl_manif ${1} ${2}
		else
			ctrl_manif ${1}
		fi
	;;
	*)
		print_error 1
	;;
esac
