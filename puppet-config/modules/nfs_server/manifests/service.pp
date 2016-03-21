#
class nfs_server::service inherits nfs_server {

  service { $nfs_server::serv :
    ensure       => $nfs_server::serv_ensure,
    subscribe    => File[$nfs_server::cfg],
  }

}
