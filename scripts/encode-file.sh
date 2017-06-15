#!/bin/bash
#
# Copyright (C) 2016-2017 EDF SA
# Contact:
#       CCN - HPC <dsp-cspit-ccn-hpc@edf.fr>
#       1, Avenue du General de Gaulle
#       92140 Clamart
#
# Authors: CCN - HPC <dsp-cspit-ccn-hpc@edf.fr>
#
# This file is part of puppet-hpc.
#
# puppet-hpc is free software: you can redistribute in and/or
# modify it under the terms of the GNU General Public License,
# version 2, as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with puppet-hpc. If not, see
# <http://www.gnu.org/licenses/>.

if [ $# -ne 3 ]; then
    echo "usage: $0 <internal_repo> <cluster> <file>"
    exit 1
fi

INTERNAL_REPO=$1
CLUSTER=$2
SRC_FILE=$3
ENC_FILE=${SRC_FILE}.enc

CLUSTER_YAML=${INTERNAL_REPO}/hieradata/${CLUSTER}/cluster.yaml
ENCODING_KEY=$(grep ^cluster_decrypt_password ${CLUSTER_YAML} | eyaml decrypt --stdin 2>/dev/null | tr -s ' ' |cut -d' ' -f2)

if [ -z ${ENCODING_KEY} ]; then
    echo "ERR: unable to parse cluster_decrypt_password in ${CLUSTER_YAML}"
    exit 1
fi

echo generating encoded file ${ENC_FILE}
openssl aes-256-cbc -in ${SRC_FILE} -out ${ENC_FILE} -k ${ENCODING_KEY}
