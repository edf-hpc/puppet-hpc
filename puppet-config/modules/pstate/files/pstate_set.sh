#!/bin/bash
##########################################################################
#  Set pstate tuning                                                     #
#                                                                        #
#  Copyright (C) 2014-2017 EDF S.A.                                      #
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

# Disable turbo
echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
# Using performance instead of powersave would reactivate
# the turbo.
for c in  /sys/devices/system/cpu/cpu*/cpufreq; do
    echo powersave >  $c/scaling_governor
done
# Force the pstate to always be at the max frequency
echo 100 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
echo 100 > /sys/devices/system/cpu/intel_pstate/min_perf_pct
