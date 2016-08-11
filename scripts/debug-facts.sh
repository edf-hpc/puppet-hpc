#!/bin/bash

hpc_puppet_modules_dirs=/etc/puppet/environments/production/modules_*

for dir in ${hpc_puppet_modules_dirs}
do
  for module_dir in ${dir}/*
  do
    FACTERLIB="$FACTERLIB:${module_dir}/lib/facter"
  done
done

export FACTERLIB

facter "${@}"
