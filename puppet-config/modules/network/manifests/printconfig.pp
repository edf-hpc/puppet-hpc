define network::printconfig ($target = 'eth0') {

  if $::osfamily == 'Debian' {
    $filename = $network::commons::cfg
    $tplname  = 'network/interfaces.erb'
    $execmd   = '/bin/systemctl reload networking'
    $execname = 'reload_net'
  }
  elsif $::osfamily == 'Redhat' {
    $filename = "${network::commons::cfg}-${target}"
    $tplname  = 'network/ifcfg.erb'
    $execmd   = "/bin/systemctl stop ifup@${target}.service && /bin/systemctl start ifup@${target}.service"
    $execname = "restart_${target}"
  }

  file { $filename :
    content    => template($tplname),
  }

  exec { $execname:
    command     => $execmd,
    subscribe   => File[$filename],
    refreshonly => true,
  }
}

