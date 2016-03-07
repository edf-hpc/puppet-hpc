class debug {

  file { '/tmp/test' :
    content => decrypt('/tmp/toto','Lolito'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

