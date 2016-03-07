define tools::decryptor($file = $title, $source = '', $mode = '600') {

  if $source == '' {
    $target = "${file}.enc"
  } else {
    $target = $source
  }

  $script = "${prerequisites::params::libpath}/../utils/decrypt_file.rb"

  exec { $target :
    command => "${script} ${target} ${file} ${mode}",
    require => File[$target],
  }

}
