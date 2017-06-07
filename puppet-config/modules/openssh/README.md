# openssh

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What openssh affects](#what-openssh-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with openssh](#beginning-with-openssh)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description
Install and configure openssh client and server

This module installs and configures OpenSSH clients and servers as is
frequently seen in HPC cluster. It authorize a root key on every node and
permits to have stable and deterministic hosts keys accross nodes reinstall.

## Setup

### What openssh affects

The `openssh::server` class **will authorize a specific key to connect as
root**, you must provide your own key to avoid using a default key that is
[published on the Internet](https://github.com/edf-hpc/puppet-hpc/tree/master/puppet-config/modules/openssh/files).

The `openssh::client` will (by default) deactivate the `StrictHostKeyChecking` 
setting. This means that the client will automatically trust new hosts without
a prompt.

### Setup Requirements

The module uses the following modules:

* edfhpc-hpclib

The ``puppet_role`` fact should be defined.

### Beginning with openssh

Generate keys for your local site:

* RSA root keys
* Hosts keys

Private keys should be encrypted with OpenSSL (see encryption in hpclib mdoule).

Make the keys available to the nodes (puppet, HTTP, local file...), and set
the source values for the keys: 

* `::openssh::server::root_public_key`
* `::openssh::server::hostkeys_source_dir`

The key must be added as a resource ``::openssh::client::identity`` to the
administration nodes.

After applying the server class, if you already connected to the server, you
might have to remove the entries in your `~/.ssh/known_hosts` file.

## Usage

### Server

The server class installs:

- The server itself
- Some configuration options
- A root public key
- Host keys

Host keys are downloaded and decrypted with the hpclib ``decrypt()`` function.

Each key will be searched in the following order:

- ``$hostkeys_source_dir/$key_name.$hostname.enc``
- ``$hostkeys_source_dir/$key_name.$puppet_role.enc``
- ``$hostkeys_source_dir/$key_name.default.enc``

Note: the public key is not downloaded but regenerated on the host from the
private key.

The module provides a default public root key this should never be used in
production. You must override it with the `root_public_key` parameter.

Note this is the actual key without the `ssh-rsa` and user name, not a
file path.

```
class{'::openssh::server':
  cluster             => 'cluster',
  root_public_key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDxPBL2D3+fW/GTjCpUI+kVAg6s1M8Z0lRRX35ecodrgz09X70tMFC2h9brXrY2557abUX3jy+0khEV81p24havY9Zi6+7rAqaB3ehCwIPTRT0vqCmHzWSOwK6WJbtur2xnXGvlwM/ngtE/RfUfbPU0Kvb6DG+kWedzi3stwyF4mRkOUahg2l0h+hKHHo46XJFI/bUfNP1ybFSAWYdkYP5Fy2pXK8JdUnYIp5wQIU6waeGUf/fEHPlyZC9fGWqygtSzOCXo3v7KQP9OLW9bupOuXi8zTt4fDKB9qQRjezt4sgnhG/yd/UwQupenIMh2m3DMAX2/e0+w6b1ORP8lzCpd',
  hostkeys_source_dir => 'http://files.hpc.example.com/private/hostkeys',
  decrypt_password    => 'passw0rd',
  config_augeas       => [
    'set ClientAliveInterval 300',
    'set AcceptEnv/1 LANG',
    'set AcceptEnv/2 LC_*',
    'set AcceptEnv/3 SLURM_*',
  ],
}
```

### Client

The client class simply configures system wide default settings for SSH
clients.

```
class{'::openssh::client': }
```

### Client Identity

The ``::openssh::client::identity`` resource configures a user private key file
and configure it in a user config file.

```
::openssh::client::identity{'backup_server_key':
  key_enc        => 'http://files.hpc.example.com/private/keys/id_rsa_backup.enc',
  config_file    => '/root/.ssh/config',
  host           => 'backup.hpc.example.com',
  decrypt_passwd => 'passw0rd',
}
  
```

The private key ``key_enc`` is decrypted with `hpclib::decrypt` and
put on the file system. The public key is generated with the same name
suffixed `.pub`.

An entry is added to the ``config_file`` like this:
```
Host <$host>
IdentityFile <$key_file>
```

Multiple entries are authorized for the same host, the same key file
can be re-used for other files and/or hosts.

If the `ensure` parameter is defined as `absent`, the files (private
and public keys) are removed and the entry is removed from the config
file


## Limitations

Server class is tested on RedHat (RHEL, CentOS) and Debian.

Client class is tested only on Debian.

## Development

Patches and issues can be submitted on GitHub:
https://github.com/edf-hpc/puppet-hpc
