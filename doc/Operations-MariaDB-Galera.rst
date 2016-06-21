Operations - MariaDB/Galera
***************************

Init/Start
==========

You have to perform this operation anytime the cluster is completely
down (first boot or full reboot).

::

    # echo MYSQLD_ARGS=--wsrep-new-cluster > /etc/default/mysql
    # systemctl start mysql
    # rm /etc/default/mysql

