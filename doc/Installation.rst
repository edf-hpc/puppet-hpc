Installation
************

Installing the configuration will depend of your cluster topology. This
page only describes most simple.

Shared ``/admin``
=================

In this setup, a storage space is mounted on every nodes of the cluster
and the configuration is applied directly from this storage space. By
default this space is mounted on ``/admin``, using another mount point
should not be difficult.

On simple systems, it is possible to use an NFS server to make
``/admin`` available on all nodes. It is also possible to bootstrap the
cluster with a ``/admin`` on the *Admin Server* exported by NFS and
later move it to a more resilient location (HA NFS, CephFS or GPFS).

Directory layout
----------------

The layout setup should be done on the first node with ``/admin``
available. This is generally the *Admin Server*.

-  ``/admin``
-  ``restricted``

   -  ``puppet-hpc`` (A git clone of the puppet-hpc repository)
   -  ``puppet-config``
   -  ``hieradata``
   -  ``hpc-privatedata`` (Frequently another git repository)
   -  ``hieradata``
   -  ``files``
   -  ``hieradata``
   -  ``generic`` (Symbolic link to
      ``/admin/restricted/puppet-hpc/hieradata``)
   -  ``private`` (Symbolic link to
      ``/admin/restricted/hpc-privatedata/hieradata``)
   -  ``privatefiles`` (Symbolic link to
      ``/admin/restricted/hpc-privatedata/files``)

-  ``public``

   -  ``http``

Puppet
------

Puppet must be configured to search for the modules in the shared
``/admin``. The following file can be used on debian and also search
modules installed with debian packages:

.. code:: ini

    [main]
    logdir=/var/log/puppet
    vardir=/var/lib/puppet
    ssldir=/var/lib/puppet/ssl
    rundir=/var/run/puppet
    basemodulepath=$confdir/modules:/usr/share/puppet/modules:/admin/restricted/puppet-hpc/puppet-config/cluster:/admin/restricted/puppet-hpc/puppet-config/modules
    prerun_command=/etc/puppet/etckeeper-commit-pre
    postrun_command=/etc/puppet/etckeeper-commit-post
    stringify_facts=false
    hiera_config=/etc/puppet/hiera.yaml

    [master]
    # These are needed when the puppetmaster is run by passenger
    # and can safely be removed if webrick is used.
    ssl_client_header = SSL_CLIENT_S_DN 
    ssl_client_verify_header = SSL_CLIENT_VERIFY

Hiera-eyaml
-----------

It is recomended to use `Hiera
EYAML <https://github.com/TomPoulton/hiera-eyaml>`__ to store secret
values. The keys must be created on the first node.

::

    # mkdir /etc/puppet/secure
    # cd /etc/puppet/secure/
    # eyaml createkeys
    [hiera-eyaml-core] Created key directory: ./keys
    Keys created OK
    # chown -R puppet:puppet /etc/puppet/secure/keys
    # chmod -R 0500 /etc/puppet/secure/keys
    # chmod 0400 /etc/puppet/secure/keys/*.pem

To configure ``eyaml(1)`` itself, the following file should be created:
``/etc/eyaml/config.yaml``

.. code:: yaml

    ---
    pkcs7_private_key: '/etc/puppet/secure/keys/private_key.pkcs7.pem'
    pkcs7_public_key: '/etc/puppet/secure/keys/public_key.pkcs7.pem'

Hiera is configured to search for values in the generic configuration
repository, then in a few files for all nodes, then in files specific
for each *role*.

.. code:: yaml

    :backends:
      - eyaml
    :eyaml:
      :datadir:           /admin/restricted/hieradata
      :pkcs7_private_key: /etc/puppet/secure/keys/private_key.pkcs7.pem
      :pkcs7_public_key:  /etc/puppet/secure/keys/public_key.pkcs7.pem
      :extension:         'yaml'
    :hierarchy:
      - private/default/roles/%{puppet_role}
      - generic/default/roles/%{puppet_role}
      - private/cluster
      - private/network
      - private/default
      - generic/common
      - generic/%{osfamily}/common

Node bootstraping
-----------------

Setting up the directory layout can be done once, but you will still
have to do some bootstraping on other newly installed nodes. Those steps
will be handled by the bootsystem eventually.

The steps are:

-  Distributing the puppet configuration
-  Distributing the hiera configuration and keys
-  Mounting ``/admin``

