class profiles::p2p::tracker {

  $admin_node    = $hosts_by_role['admin']
  $tracker_nodes = $hosts_by_role["$my_p2p_tracker"]

  class { '::opentracker':
    admin_node    => $admin_node,
    tracker_nodes => $tracker_nodes,
  }
}
