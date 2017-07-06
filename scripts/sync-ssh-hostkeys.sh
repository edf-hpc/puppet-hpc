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

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "usage: $0 <internal_repo> <cluster> [<domain>]"
    exit 1
fi

INTERNAL_REPO=$1
CLUSTER=$2
DOMAIN=${3:-$(hostname -d)}

if [ ! -d ${INTERNAL_REPO} ]; then
    echo "ERR: internal repository ${INTERNAL_REPO} does not exist"
    exit 1
fi

SSH_KEYS_DIR=${INTERNAL_REPO}/files/${CLUSTER}/hostkeys
KNOWN_HOSTS_FILE=${INTERNAL_REPO}/files/${CLUSTER}/ssh/known_hosts
CLUSTER_YAML=${INTERNAL_REPO}/hieradata/${CLUSTER}/cluster.yaml

if [ ! -d ${SSH_KEYS_DIR} ]; then
    echo "creating ${SSH_KEYS_DIR}"
    mkdir -p ${SSH_KEYS_DIR}
fi

if [ ! -d "$(dirname ${KNOWN_HOSTS_FILE})" ]; then
    echo "creating $(dirname ${KNOWN_HOSTS_FILE})"
    mkdir -p "$(dirname ${KNOWN_HOSTS_FILE})"
fi

TMP_KNOWN_HOSTS_FILE="$(mktemp --tmpdir tmp_known_hostsXXXXXX)"

function gen_key {
    TYPE=$1
    HOST=$2
    other_names="${3}"
    # generate the key only if it does not exist
    if [ ! -f ${SSH_KEYS_DIR}/ssh_host_${TYPE}_key.${HOST}.enc ]; then
        echo "generating ${HOST} ${TYPE} key"
        ssh-keygen -q -t $TYPE -N '' -C root@${HOST} -f ${SSH_KEYS_DIR}/ssh_host_${TYPE}_key.${HOST}
        puppet-hpc/scripts/encode-file.sh ${INTERNAL_REPO} ${CLUSTER} ${SSH_KEYS_DIR}/ssh_host_${TYPE}_key.${HOST}
        # remove unencrypted private key
        rm ${SSH_KEYS_DIR}/ssh_host_${TYPE}_key.${HOST}
    fi
    for name in $HOST $other_names
    do
        echo -n "${name} " >> "${TMP_KNOWN_HOSTS_FILE}"
        cat "${SSH_KEYS_DIR}/ssh_host_${TYPE}_key.${HOST}.pub" >> "${TMP_KNOWN_HOSTS_FILE}"
    done
}



echo -n > "${TMP_KNOWN_HOSTS_FILE}"
 

puppet-hpc/scripts/hostlist -fiad $DOMAIN ${INTERNAL_REPO} ${CLUSTER} | while read HOST other_names
do
    gen_key 'rsa' $HOST "${other_names}"
    gen_key 'dsa' $HOST "${other_names}"
    gen_key 'ecdsa' $HOST "${other_names}"
    gen_key 'ed25519' $HOST "${other_names}"
done

cat > "${KNOWN_HOSTS_FILE}" <<EOF
# This file was generated by the scripts puppet-hpc/scripts/sync-ssh-hostkeys.sh
#
# The content is based on a hostlist generated from the content of the cluster
# network.yaml file. The host keys are the one read from the files:
# hpc-privatedata/files/$CLUSTER/hostkeys/ssh_host_<TYPE>_key.<HOST>.pub.
EOF

sort "${TMP_KNOWN_HOSTS_FILE}" >> "${KNOWN_HOSTS_FILE}"

rm "${TMP_KNOWN_HOSTS_FILE}"
