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
# HPCStats is free software: you can redistribute in and/or
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

if [ $# -ne 2 ]; then
    echo "usage: $0 <internal_repo> <cluster>"
    exit 1
fi

INTERNAL_REPO=$1
CLUSTER=$2

if [ ! -d ${INTERNAL_REPO} ]; then
    echo "ERR: internal repository ${INTERNAL_REPO} does not exist"
    exit 1
fi

SSH_KEYS_DIR=${INTERNAL_REPO}/files/${CLUSTER}/hostkeys
CLUSTER_YAML=${INTERNAL_REPO}/hieradata/${CLUSTER}/cluster.yaml
NETWORK_YAML=${INTERNAL_REPO}/hieradata/${CLUSTER}/network.yaml
ENCODING_KEY=$(grep cluster_decrypt_password ${CLUSTER_YAML} | eyaml decrypt --stdin 2>/dev/null | cut -d' ' -f2)

if [ -z ${ENCODING_KEY} ]; then
    echo "ERR: unable to parse cluster_decrypt_password in ${CLUSTER_YAML}"
    exit 1
fi

if [ ! -d ${SSH_KEYS_DIR} ]; then
    echo "creating ${SSH_KEYS_DIR}"
    mkdir -p ${SSH_KEYS_DIR}
fi

function gen_key {
    TYPE=$1
    HOST=$2
    # generate the key only if it does not exist
    if [ ! -f ${SSH_KEYS_DIR}/ssh_host_${TYPE}_key.${HOST}.enc ]; then
        echo "generating ${HOST} ${TYPE} key"
        ssh-keygen -q -t $TYPE -N '' -f ${SSH_KEYS_DIR}/ssh_host_${TYPE}_key.${HOST}
        openssl aes-256-cbc -in ${SSH_KEYS_DIR}/ssh_host_${TYPE}_key.${HOST} -out ${SSH_KEYS_DIR}/ssh_host_${TYPE}_key.${HOST}.enc -k ${ENCODING_KEY}
        # remove unencrypted private key
        rm ${SSH_KEYS_DIR}/ssh_host_${TYPE}_key.${HOST}
    fi
}
 
for HOST in $(puppet-hpc/scripts/hostlist $NETWORK_YAML); do
    gen_key 'rsa' $HOST
    gen_key 'dsa' $HOST
    gen_key 'ecdsa' $HOST
    gen_key 'ed25519' $HOST
done
