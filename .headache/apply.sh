#!/bin/bash
headache_dir=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
headache -r -h ${headache_dir}/HEADER -c ${headache_dir}/CONFIG "$@"

