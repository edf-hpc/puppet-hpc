class debug {

  file { '/tmp/test' :
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  ensure_resource('file', '/tmp/test', {'ensure' => 'directory' })


}

