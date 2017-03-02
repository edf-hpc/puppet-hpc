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


# Decode a file and reencode it with the keys in the argument files

if [ $# -ne 3 ]; then
    echo "usage: $0 <oldkey_file> <newkey_file> <encoded_file>"
    exit 1
fi

OLDKEY_FILE="$1"
NEWKEY_FILE="$2"
SRC_FILE="$3"

clear_file="$(dirname ${SRC_FILE})/$(basename ${SRC_FILE} .enc)"

echo "Re-encoding ${SRC_FILE}"
openssl aes-256-cbc -d -in "${SRC_FILE}" -out "${clear_file}" -kfile "${OLDKEY_FILE}"
openssl aes-256-cbc    -in "${clear_file}" -out "${SRC_FILE}" -kfile "${NEWKEY_FILE}"
rm "${clear_file}"
