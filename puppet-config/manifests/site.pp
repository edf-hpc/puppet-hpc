node default {
  class {'mariadb': 
    mysql_root_pwd => 'password'
  }
}
