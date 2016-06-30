# puppet-hpc
Generic Puppet Configuration for HPC Clusters

**IMPORTANT:**
Currently, there are several iterations and work in progress around this configuration.Some part of the configuration are still incomplete or could change. This configuration uses packages, data and documentation not published yet.

## Project Goals and Origin

The project is an effort to produce a puppet configuration suitable for an HPC cluster. It is based on an effort from the EDF HPC team to factor the puppet configuration between its HPC clusters. It is not meant to be specific to EDF systems though.

EDF HPC team is focused on Debian support, but contributions related to other distributions are welcome. 

## Pinciples

The design is using the pattern of roles and profiles exposed here: https://puppet.com/presentations/designing-puppet-rolesprofiles-pattern

The cluster is configured through hiera, this git repository only contains the hiera files default configurations. The actual site data must be provided from another source. Hiera also contains a description of the cluster as a whole (list of machines, networks...), those data can be used by profiles or high-level modules.

The configuration makes use from generic module from the puppet forge when possible. The modules integrated in the configuration should have the *approved* status.

## Documentation

The main documentation sources are the github pages: https://edf-hpc.github.io//puppet-hpc

Documentation is generated from the `puppet strings` and `asciidoc` in the `/doc` directory of this git repository.


