class profiles::auth::client {

  ## Hiera lookups

  $sssd_options_general           = hiera_hash('profiles::auth::client::sssd_options_general')
  $sssd_options_nss               = hiera_hash('profiles::auth::client::sssd_options_nss')
  $sssd_options_pam               = hiera_hash('profiles::auth::client::sssd_options_pam')
  $sssd_options_domain            = hiera_hash('profiles::auth::client::sssd_options_domain')
  $krb5_options                   = hiera_hash('profiles::auth::client::krb5_options')
  $enable_kerberos                = hiera('profiles::auth::client::enable_kerberos')
  $keytab_directory_source        = hiera('profiles::auth::client::keytab_directory_source')
  $cluster                        = hiera('cluster')

  if $enable_kerberos {
    $sssd_options_domain_kerberos_opts = {
      krb5_server                    => hiera('profiles::auth::client::krb5_server'),
      krb5_realm                     => hiera('profiles::auth::client::krb5_realm'),
      krb5_store_password_if_offline => hiera('profiles::auth::client::krb5_store_password_if_offline'),
      auth_provider                  => 'krb5',
    }
  }
  else {
    $sssd_options_domain_kerberos_opts = {
      auth_provider                  => 'ldap',
    }
  }

  $sssd_options = { 
    sssd => $sssd_options_general,
    nss  => $sssd_options_nss,
    pam  => $sssd_options_pam,
    "domain/${cluster}" => merge($sssd_options_domain,$sssd_options_domain_kerberos_opts),
  }

  include certificates

  class { '::sssd':
    sssd_options    => $sssd_options,
    cluster         => $cluster,
  }
  class { '::kerberos':
    config_options          => $krb5_options, 
    keytab_directory_source => $keytab_directory_source,
  }

  include ::pam
  include ::pam::sss
}
