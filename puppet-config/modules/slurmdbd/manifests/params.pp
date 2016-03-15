class slurmdbd::params {

  $jobsc_dbd_cfg_tpl = 'jobsched/slurmdbd_conf.erb'
  $jobsc_dbd_setup_conf_tpl = 'jobsched/slurm-mysql.erb'

  ### Service ###
  $service_enable   = true
  $service_ensure   = 'running'
  $service_manage   = true
  $service_name     = 'slurmdbd'
  
  ### Configuration ###
  $config_manage         = true
  $bin_dir_path          = '/usr/lib/slurm'
  $conf_dir_path         = '/etc/slurm-llnl'
  $logs_dir_path         = '/var/log/slurm-llnl'
  $main_conf_file        = "${conf_dir_path}/slurmdbd.conf"
  $dbd_conf_file         = "${conf_dir_path}/slurm-mysql.conf"
  $dbd_backup_script     = "${bin_dir_path}/slurmdbd-backup.sh"
  $dbd_backup_src        = 'puppet:///modules/slurmdbd/slurmdbd-backup.sh'
  $dbd_backup_include    = "${bin_dir_path}/slurmdbd-backup.var"

  $main_conf_options = {
    'DbdHost'              => 'localhost',
    'DbdBackupHost'        => '',
    'DbdPort'              => '6819',
    'SlurmUser'            => 'slurm',
    'DebugLevel'           => '3', 
    'AuthType'             => 'auth/munge',
    'AuthInfo'             => '/var/run/munge/munge.socket.2',
    'LogFile'              => "${logs_dir_path}/slurmdbd.log", 
    'PidFile'              => '/var/run/slurm-llnl/slurmdbd.pid',
    'StorageType'          => 'accounting_storage/mysql',
    'StorageHost'          => 'localhost',
    'StorageBackupHost'    => '',
    'StorageUser'          => 'slurm',
    'StoragePass'          => 'password',
  }

  $dbd_conf_options      = {
    'db'                   => {
      'hosts'                => 'localhost',
      'user'                 => 'root',
      'password'             => 'password',
    },
    'passwords'            => {
      'slurm'                => 'password',
      'slurmro'              => 'password',
    },
    'hosts'                => {
      'controllers'          => '',
      'admins'               => '',
    },
  }

  case $::osfamily {
    'RedHat': {
      $db_conf   = '/etc/mysql/my.cnf'
      $dbbackup_enable = true
    }
    'Debian': {
      $db_conf   = '/etc/mysql/debian.cnf'
      $dbbackup_enable = true
    }
    default: {
      $dbbackup_enable = false
    }
  }
 

  $backup_include_options = {
    'BKDIR'                => '/admin/restricted/backups/slurmdbd',
    'ACCTDB'               => 'slurm_acct_db',
    'DBMAINCONF'           => $db_conf,
  }


  ### Package ###
  $package_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $package_manage =  true
      $package_name   = ['slurm-slurmdbd']
    }
    'Debian': {
      $package_manage =  true
      $package_name   = ['slurmdbd','slurm-llnl-setup-mysql']
    }
    default: {
      $package_manage    =  false
    }
  }
}
