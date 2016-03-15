#
class nfs_client::service inherits nfs_client {

  service { $nfs_client::serv :
    ensure       => $nfs_client::serv_ensure,
  }

}
