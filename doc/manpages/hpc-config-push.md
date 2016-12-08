% hpc-config-push (1)

# NAME

hpc-config-push - push puppet-hpc configuration into central storage

# SYNOPSIS

    hpc-config-push

# DESCRIPTION

hpc-config-push pushes pushes a puppet-hpc configuration into a 
central storage, to be used by hpc-config-apply on cluster nodes.
It includes the puppet-hpc git repository, private data and files, and
system packaged puppet modules.

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

# DIRECTORY LAYOUT

Source directories (git puppet-hpc and git hpc-privatedata), can be placed 
anywhere on the Admin/Development machine. They should be in the same place
though.

    * <SOME DIRECTORY>
      * puppet-hpc (a git clone of the puppet-hpc repository)
      * hpc-privatedata (a directory containing cluster specific data, 
        frequently another git repository)
        * hieradata
        * files

The destination should be shared between the central storage servers. It must be 
accessible as a simple POSIX filesystem, or via S3 Amazon API.

# CONFIGURATION FILE

The default configuration file is installed at '/etc/hpc-config/push.conf' and 
it is a simple text file using the 
[INI file format](http://en.wikipedia.org/wiki/INI_file).
This file has a basic structure composed of sections, properties, and values.

The '[global]' section defines the defaults parameters used:

    [global]
    cluster = <cluster name>
    environment = <default environment>
    version = <default version>
    destination = <default directory on central storage>
    mode = <push mode, can be s3 or posix>

Then it can have an '[s3]' section:

    [s3]
    access_key = <access key for s3>
    secret_key = <secret key for s3>
    bucket_name = <bucket to use on s3>
    host = <host where to push data>
    port = <port to use>

And/Or a '[paths]' section:

    [paths]
    tmp = <tmpdir where to build tarball> (default: /tmp/hpc-config-push)
    puppethpc = <directory where to find puppet-hpc git repository> 
                (default: puppet-hpc)
    privatedata = <directory where to find privates data> 
                  (default: hpc-privatedata)
    puppet_conf = <directory where to find pupet.conf file> (default:
                  ${privatedata}/puppet-config/${global:cluster}/puppet.conf)
    hiera_conf = <directory where to find pupet.conf file> (default: 
                 ${privatedata}/puppet-config/${global:cluster}/hiera.yaml)
    facts_private = ${privatedata}/puppet-config/${global:cluster}/hpc-config-facts.yaml
    modules_generic = <directories where to find generic puppet modules>
                      (default: ${puppethpc}/puppet-config/cluster,
                       ${puppethpc}/puppet-config/modules,
                       /usr/share/puppet/modules)
    modules_private = <directories where to find private puppet modules> (default: 
                      ${privatedata}/puppet-config/${global:cluster}/modules)
    manifests_generic = <directory where to find generic manifests>
                        (default: ${puppethpc}/puppet-config/manifests)
    manifests_private = <directory where to find private manifests> (default: 
                        ${privatedata}/puppet-config/${global:cluster}/manifests)
    hieradata_generic = <directory where to find generic Hiera files>
                        (default: ${puppethpc}/hieradata)
    hieradata_private = <directory where to find private Hiera files>
                        (default: ${privatedata}/hieradata)
    files_private = <directory where to find private files to put on nodes>
                    (default: ${privatedata}/files/${global:cluster})

All the values in the '[paths]' section are optionnal, if not defined the default value applies.

# EXAMPLES

To simply push the actual configuration in default environment

    hpc-config-push

To push the actual configuration in the 'test' environment

    hpc-config-push -e test

# SEE ALSO

hpc-config-apply(1)
