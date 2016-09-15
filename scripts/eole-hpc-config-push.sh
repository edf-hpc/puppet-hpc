#!/bin/bash

script_dir="$(readlink -f $(dirname "${BASH_SOURCE[0]}"))"
${script_dir}/hpc-config-push -c ~/ccnhpc/thomas/push.conf

