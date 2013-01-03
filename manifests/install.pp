class foreman::install {
  if ! $foreman::custom_repo {
    foreman::install::repos { 'foreman':
      repo => $foreman::repo
    }
  }

  $repo = $foreman::custom_repo ? {
    true    => [],
    default => Foreman::Install::Repos['foreman'],
  }

  package {'foreman':
    ensure  => present,
    require => $repo,
    notify  => Class['foreman::service'],
  }

  $database_settings = $foreman::database_settings
  case $database_settings['adapter'] {
    undef: {
      fail('You must set the adapter in your database_settings')
    }
    'sqlite3': {
      case $::operatingsystem {
        Debian,Ubuntu: { $sqlite = "foreman-sqlite3" }
        default:       { $sqlite = "foreman-sqlite" }
      }

      package {'foreman-sqlite3':
        name => $sqlite,
        ensure  => latest,
        require => $repo,
        notify  => [Class['foreman::service'],Package['foreman']],
      }

    }
    'mysql': {
      fail('Please use \'mysql2\' as database adapter.')
    }
    'mysql2': {
      case $::operatingsystem {
        default:       { $mysql = 'foreman-mysql2' }
      }
      package {'foreman-mysql':
        name    => $mysql,
        ensure  => latest,
        require => $repo,
        notify  => [Class['foreman::service'], Package['foreman']],
      }
    }
    default: {
      warn('You will have to install the supporting ruby packages for this adapter yourself')
    }

  }

}
