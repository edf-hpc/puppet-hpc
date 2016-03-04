class profiles::http::mirror {

  ## Hiera lookups

  $net_opts     = {
    mynetworks    => "127.0.0.0/8",
  }
  $cl_opts      = hiera_hash('profiles::postfix::client::cfg_opts')

  $profile_opts = merge($cl_opts,$net_opts)
 
  # Pass config options as a class parameter
  apache::vhost { '*:80' :
    port           => $port,
    docroot        => $docroot,
    serveradmin    => $serveradmin,
    error_log_file => $error_log_file,
    log_level      => $log_level,
  }
}
