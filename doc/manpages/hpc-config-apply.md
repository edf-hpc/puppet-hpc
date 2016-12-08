% hpc-config-apply (1)

# NAME

hpc-config-apply - download and apply a puppet-hpc configuration

# SYNOPSIS

    hpc-config-apply

# DESCRIPTION

hpc-config-apply downloads via http protocal and apply a puppet-hpc 
configuration on a cluster node.

# OPTIONS

  -h, --help            show this help message and exit
  --dry-run             Don't actually perform configuration (still downloads
                        env).
  --config [CONFIG_FILE], -c [CONFIG_FILE]
                        Configuration file
  --source [SOURCE], -s [SOURCE]
                        Configuration source URL
  --environment [ENVIRONMENT], -e [ENVIRONMENT]
                        Environment name
  --tmpdir [TMPDIR], -t [TMPDIR]
                        Change TMPDIR env for puppet run.
  --deploy-step [{production,usbdisk}], -d [{production,usbdisk}]
                        Deploy step
  --keys-source [KEYS_SOURCE], -k [KEYS_SOURCE]
                        Secret keys source
  --tags [TAGS]         Puppet tags (comma separated list)
  --verbose, -v         More output, can be specified multiple times.

# CONFIGURATION FILE

The default configuration file is installed at '/etc/hpc-config.conf' and it
is a simple text file using the [INI file format](
http://en.wikipedia.org/wiki/INI_file).
This file has a basic structure composed of sections, properties, and values.
The lines starting with a semi-colon are commentaries and they're ignored.
Each section describes an environment, the '[DEFAULT]' section is used when no
environment is specified via the '-e' option.
In each section, each option of the command line can bedefined (except 
config file).
Here is an example of a typical file with only a '[DEFAULT]' section:

    [DEFAULT]
    environment=production
    source=http://masternode/hpc-config
    keys_source=http://masternode/secret

# EXAMPLES

To simply apply the default puppet environment

    hpc-config-apply

To apply the 'test' environment in verbose mode

    hpc-config-apply -v -e test

# SEE ALSO

hpc-config-push(1)
