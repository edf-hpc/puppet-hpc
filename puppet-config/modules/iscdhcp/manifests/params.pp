#
class iscdhcp::params {

  $peer_address               = ""
  $virtual_address            = ""
  $bootmenu_url               = ""
  $ipxebin                    = ""
  $includes                   = {}
  $dhcp_config                = {}
  $packages                   = ['isc-dhcp-server']
  $packages_ensure            = 'present'
  $config_file                = '/etc/dhcp/dhcpd.conf'
  $global_options             = []
  $failover                   = {}
  $sharednet                  = {}
  $default_file               = '/etc/default/isc-dhcp-server'
  $default_options            = ['INTERFACES= eth0']
  $service                    = 'isc-dhcp-server'
  $service_ensure             = ''
  $systemd_config_file        = "/etc/systemd/system/${service}.service"
  $systemd_config_options     = {
    'Unit'    => {
      'Description'     => 'ISC DHCP server',
      'After'           => 'network.target',
    },
    'Service' => {
      'Type'            => 'forking',
      'EnvironmentFile' => $default_file,
      'ExecStartPre'    => "/usr/sbin/dhcpd -t \$OPTIONS -cf ${config_file}",
      'ExecStart'       => "/usr/sbin/dhcpd -q \$OPTIONS -cf ${config_file} -pf /var/run/dhcpd.pid \$INTERFACES",
      'PIDFile'         => '/var/run/dhcpd.pid',
      # restart on-failure is needed to retry starting the service until bond0
      # is available. Unfortunately, the after network.target does not do the
      # job, systemd keeps trying to start dhcpd before the network interface
      # is available and it fails. This is the less horrible workaround that
      # has been found so far.
      'Restart'         => 'on-failure',
    },
    'Install' => {
      'WantedBy'        => 'multi-user.target',
    },
  }

}
