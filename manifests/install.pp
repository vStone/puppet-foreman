# = Class: foreman::install
#
# Installs required packages on the system.
#
# == Requires:
#
# foreman::install:repos
#
class foreman::install {

  require foreman::params
  $use_repo = $foreman::params::use_repo

  case $::operatingsystem {
    Debian,Ubuntu:  {
      package {'foreman-sqlite3':
        ensure  => latest,
        notify  => [Class['foreman::service'],
                    Package['foreman']],
      }
    }
    default: {}
  }

  package {'foreman':
    ensure  => latest,
    notify  => Class['foreman::service'],
  }

  if $use_repo {
    include foreman::install::repos
    Package['foreman'] {
      require => Class['foreman::install::repos'],
    }
    if defined(Package['foreman-sqlite3']) {
      Package['foreman-sqlite3'] {
        require => Class['foreman::install::repos'],
      }
    }
  }

}
