% hpc-config-push (1)

# NAME

hpc-config-push - push puppet-hpc configuration into central storage

# SYNOPSIS

    hpc-config-push [-h] [-d] [-c [CONF]] [-e [ENVIRONMENT]] [-V [VERSION]]
                    [--full-tmp-cleanup]

# DESCRIPTION

hpc-config-push makes available all the Puppet configuration into
a shared central storage to be used by hpc-config-apply on cluster nodes.
The pushed data includes the public puppet-hpc configuration, the
private data and files and packaged Puppet modules.

# OPTIONS

    -h, --help            show this help message and exit
    -d, --debug           Enable debug mode
    -c [CONF], --conf [CONF]
                          Path to the configuration file
    -e [ENVIRONMENT], --environment [ENVIRONMENT]
                          Name of the pushed environment
    -V [VERSION], --version [VERSION]
                          Version of the pushed config
    --full-tmp-cleanup    Full tmp dir cleanup.
    --enable-python-warnings
                          Enable some python warnings (deprecation and
                          future warnings are hidden by default)

# DIRECTORY LAYOUT

The source directories to be pushed can be placed anywhere in the
development machine as long as they are all at the same directory. The layout
of this directory should be like in the example below:

    some_directory/
    ├── private-data
    │   ├── files
    │   └── hieradata
    └── puppet-hpc

`puppet-hpc` is a git checkout of the Generic Puppet Configuration for HPC Clusters
you downloaded with this documentation.
`private-data` is a directory containing all the specific data for your cluster.
It's advised to also keep this in git and simply fetch a copy.

The destination should be shared between all the central storage servers. It
must be accessible as a simple POSIX file system, via the Amazon S3 API or a
set of SFTP servers.

# CONFIGURATION FILE

The default configuration file is installed at `/etc/hpc-config/push.conf` and
it is a simple text file using the
[INI file format](http://en.wikipedia.org/wiki/INI_file).
This file has a basic structure composed of sections, properties, and values.

The '[global]' section defines the defaults parameters used:

    [global]
    cluster = <cluster name>
    environment = <default environment>
    version = <default version>
    destination = <default directory on central storage>
    mode = <push mode, can be 's3', 'posix' or 'sftp'>

Optionally, it can include a '[posix]' section:

    [posix]
    file_mode = <dest files mode as (octal)>
    dir_mode = <dest directories mode (octal)>

Or a '[s3]' section:

    [s3]
    access_key = <access key for s3>
    secret_key = <secret key for s3>
    bucket_name = <bucket to use on s3>
    host = <host where to push data>
    port = <port to use>

Or a '[sftp]' section:

    [sftp]
    hosts = <host>[,<host>...]
    username = <SSH username>
    private_key = <Private key file path>

And/or a '[paths]' section:

    [paths]
    tmp = <tmp directory where to build the tarball> (default: /tmp/hpc-config-push)
    puppethpc = <directory where to find the puppet-hpc git repository>
                (default: puppet-hpc)
    privatedata = <directory where to find the private data>
                  (default: hpc-privatedata)
    puppet_conf = <directory where to find puppet.conf file>
                  (default: ${privatedata}/puppet-config/${global:cluster}/puppet.conf)
    hiera_conf = <directory where to find the puppet.conf file> (default:
                 ${privatedata}/puppet-config/${global:cluster}/hiera.yaml)
    facts_private = ${privatedata}/puppet-config/${global:cluster}/hpc-config-facts.yaml
    modules_generic = <directories where to find the generic puppet modules>
                      (default: ${puppethpc}/puppet-config/cluster,
                       ${puppethpc}/puppet-config/modules,
                       /usr/share/puppet/modules )
    modules_private = <directories where to find the private puppet modules>
                      (default: ${privatedata}/puppet-config/${global:cluster}/modules)
    manifests_generic = <directory where to find the generic manifests>
                        (default: ${puppethpc}/puppet-config/manifests)
    manifests_private = <directory where to find the private manifests>
                        (default: ${privatedata}/puppet-config/${global:cluster}/manifests)
    hieradata_generic = <directory where to find the generic Hiera files>
                        (default: ${puppethpc}/hieradata)
    hieradata_private = <directory where to find the private Hiera files>
                        (default: ${privatedata}/hieradata)
    files_private = <directory where to find all the private files to put on nodes>
                    (default: ${privatedata}/files/${global:cluster})

All the values in the '[paths]' section are optional, if they are not defined,
the default value is used.

# EXAMPLES

To simply push the current configuration in the default environment:

    hpc-config-push

To push the current configuration in the 'test' environment:

    hpc-config-push -e test

# SEE ALSO

hpc-config-apply(1)
