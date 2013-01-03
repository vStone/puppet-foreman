class foreman::config {
  Cron {
    require     => User[$foreman::user],
    user        => $foreman::user,
    environment => "RAILS_ENV=${foreman::environment}",
  }

  file {'/etc/foreman/settings.yaml':
    content => template('foreman/settings.yaml.erb'),
    notify  => Class['foreman::service'],
    owner   => $foreman::user,
    require => User[$foreman::user],
  }

  case $::operatingsystem {
    Debian,Ubuntu: {
      $init_config = '/etc/default/foreman'
      $init_config_tmpl = 'foreman.default'
    }
    default: {
      $init_config = '/etc/sysconfig/foreman'
      $init_config_tmpl = 'foreman.sysconfig'
    }
  }
  file { $init_config:
    ensure  => present,
    content => template("foreman/${init_config_tmpl}.erb"),
    require => Class['foreman::install'],
    before  => Class['foreman::service'],
  }

  file { $foreman::app_root:
    ensure  => directory,
  }

  user { $foreman::user:
    ensure  => 'present',
    shell   => '/sbin/nologin',
    comment => 'Foreman',
    home    => $foreman::app_root,
    require => Class['foreman::install'],
  }

  # remove cron previously installed here, it's moved to the package's cron.d
  # file
  cron{'clear_session_table':
    ensure  => absent,
  }

  if $foreman::reports { include foreman::config::reports }
  if $foreman::passenger  {
    class {'foreman::config::passenger':
      require => Class['puppet::server'],
    }
  }

  include foreman::config::database

}
