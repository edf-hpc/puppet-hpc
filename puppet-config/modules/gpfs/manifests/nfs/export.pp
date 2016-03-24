#
define gpfs::nfs::export (
  $exportdir,
  $host                = '*',
  $options             = 'ro,sync',
  $cfg                 = '/etc/exports',
){

  if $options {
    $content = "${exportdir}    ${host}(${options})\n"
  }
  else {
    $content = "${exportdir}    ${host}\n"
  }

  concat::fragment { "${exportdir}_on_${host}":
    ensure             => 'present',
    content            => $content,
    target             => $cfg,
  }

}

