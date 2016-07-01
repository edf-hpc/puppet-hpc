[![Puppet Forge Version](http://img.shields.io/puppetforge/v/herculesteam/augeasproviders_pam.svg)](https://forge.puppetlabs.com/herculesteam/augeasproviders_pam)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/herculesteam/augeasproviders_pam.svg)](https://forge.puppetlabs.com/herculesteam/augeasproviders_pam)
[![Puppet Forge Endorsement](https://img.shields.io/puppetforge/e/herculesteam/augeasproviders_pam.svg)](https://forge.puppetlabs.com/herculesteam/augeasproviders_pam)
[![Build Status](https://img.shields.io/travis/hercules-team/augeasproviders_pam/master.svg)](https://travis-ci.org/hercules-team/augeasproviders_pam)
[![Coverage Status](https://img.shields.io/coveralls/hercules-team/augeasproviders_pam.svg)](https://coveralls.io/r/hercules-team/augeasproviders_pam)
[![Gemnasium](https://img.shields.io/gemnasium/hercules-team/augeasproviders_pam.svg)](https://gemnasium.com/hercules-team/augeasproviders_pam)


# pam: type/provider for PAM files for Puppet

This module provides a new type/provider for Puppet to read and modify PAM
config files using the Augeas configuration library.

The advantage of using Augeas over the default Puppet `parsedfile`
implementations is that Augeas will go to great lengths to preserve file
formatting and comments, while also failing safely when needed.

This provider will hide *all* of the Augeas commands etc., you don't need to
know anything about Augeas to make use of it.

## Requirements

Ensure both Augeas and ruby-augeas 0.3.0+ bindings are installed and working as
normal.

See [Puppet/Augeas pre-requisites](http://docs.puppetlabs.com/guides/augeas.html#pre-requisites).

## Installing

On Puppet 2.7.14+, the module can be installed easily ([documentation](http://docs.puppetlabs.com/puppet/latest/reference/modules_installing.html)):

    puppet module install herculesteam/augeasproviders_pam

You may see an error similar to this on Puppet 2.x ([#13858](http://projects.puppetlabs.com/issues/13858)):

    Error 400 on SERVER: Puppet::Parser::AST::Resource failed with error ArgumentError: Invalid resource type `pam` at ...

Ensure the module is present in your puppetmaster's own environment (it doesn't
have to use it) and that the master has pluginsync enabled.  Run the agent on
the puppetmaster to cause the custom types to be synced to its local libdir
(`puppet master --configprint libdir`) and then restart the puppetmaster so it
loads them.

## Compatibility

### Puppet versions

Minimum of Puppet 2.7.

### Augeas versions

Augeas Versions           | 0.10.0  | 1.0.0   | 1.1.0   | 1.2.0   |
:-------------------------|:-------:|:-------:|:-------:|:-------:|
**PROVIDERS**             |
pam                       | **yes** | **yes** | **yes** | **yes** |

## Documentation and examples

Type documentation can be generated with `puppet doc -r type` or viewed on the
[Puppet Forge page](http://forge.puppetlabs.com/herculesteam/augeasproviders_pam).


### manage simple entry

    pam { "Set sss entry to system-auth auth":
      ensure    => present,
      service   => 'system-auth',
      type      => 'auth',
      control   => 'sufficient',
      module    => 'pam_sss.so',
      arguments => 'use_first_pass',
      position  => 'before module pam_deny.so',
    }

### manage same entry but with Augeas xpath

    pam { "Set sss entry to system-auth auth":
      ensure    => present,
      service   => 'system-auth',
      type      => 'auth',
      control   => 'sufficient',
      module    => 'pam_sss.so',
      arguments => 'use_first_pass',
      position  => 'before *[type="auth" and module="pam_deny.so"]',
    }

### delete entry

    pam { "Remove sss auth entry from system-auth":
      ensure  => absent,
      service => 'system-auth',
      type    => 'auth',
      module  => 'pam_sss.so',
    }

### delete all references to module in file

    pam { "Remove all pam_sss.so from system-auth":
      ensure  => absent,
      service => 'system-auth',
      module  => 'pam_sss.so',
    }

### manage entry in another pam service

    pam { "Set cracklib limits in password-auth":
      ensure    => present,
      service   => 'password-auth',
      type      => 'password',
      module    => 'pam_cracklib.so',
      arguments => ['try_first_pass','retry=3', 'minlen=10'],
    }

### manage entry like previous but in classic pam.conf

    pam { "Set cracklib limits in password-auth":
      ensure    => present,
      service   => 'password-auth',
      type      => 'password',
      module    => 'pam_cracklib.so',
      arguments => ['try_first_pass','retry=3', 'minlen=10'],
      target    => '/etc/pam.conf',
    }

### allow multiple entries with same control value

    pam { "Set invalid login 3 times deny in password-auth -fail":
      ensure           => present,
      service          => 'password-auth',
      type             => 'auth',
      control          => '[default=die]',
      control_is_param => true,
      module           => 'pam_faillock.so',
      arguments        => ['authfail','deny=3','unlock_time=604800','fail_interval=900'],
    }

## Issues

Please file any issues or suggestions [on GitHub](https://github.com/hercules-team/augeasproviders_pam/issues).
