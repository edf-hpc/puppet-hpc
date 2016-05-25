#
class iscdhcp::service inherits iscdhcp {

  hpclib::systemd_service { $iscdhcp::systemd_config_file :
    target => $iscdhcp::systemd_config_file,
    config => $iscdhcp::systemd_config_options,
  }

  service { $dhcp_sr_serv :
    require   => Package[$iscdhcp::packages],
    subscribe => File[$iscdhcp::default_file],
  }

}
