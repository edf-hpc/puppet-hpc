#
class network::config inherits network {

  # Set hostname
  augeas { $network::aug_hname :
    context => $network::aug_hname,
    changes => $network::aug_changes,
  }

  $mlx_cfg = {
    'mlx4_load'    => $network::mlx4load,
    'mlx4_en_load' => $network::mlx4load,
  }
  $openib_cfg = merge($network::openib_cfg0, $mlx_cfg)

  # Install packages and create configuration files
  $ib_file = {
    "${network::ib_cfg}"    => {
      'content'            => template('network/openib_conf.erb'),
      'require'            => Package[$network::ib_pkgs],
    }
  }
  create_resources(file, $ib_file)

  # $net_ifaces hash is used by create_resources to generate main network
  # configuration file. On debian systems there is a single file.
  # On RHEL systems there is a file for each interface. For this reason
  # the hash is modified with the names of all interfaces in the case of RHEL.
  $net_ifaces = $::ifaces_target
  create_resources(network::printconfig, $net_ifaces)

}
