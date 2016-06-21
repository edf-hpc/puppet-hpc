Operations - OpenLDAP
*********************

Replica
=======

When you initialize your cluster, if you wish to use a local OpenLDAP
replica, you have to execute the script ``make_ldap_replica`` on your
replica node. This script will use an ldif file that you must provide.

Logging
=======

Changing log level
------------------

To change the log level on a running server you must define a logging
modification ldif file: :sub:`[STRIKEOUT:ldif dn: cn=config changetype:
modify replace: olcLogLevel olcLogLevel: stats]`

The new level is applied with this command:

::

    # ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /tmp/logging.ldif

