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
  file { "${foreman::app_root}/Gemfile.lock":
    ensure  => 'present',
    owner   => $foreman::user,
    require => [
      User[$foreman::user],
      File[$foreman::app_root],
    ]
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
  if $foreman::enc {
    class {'foreman::config::enc':
      foreman_url  => $foreman::foreman_url,
      facts        => $foreman::facts,
      storeconfigs => $foreman::storeconfigs,
      puppet_home  => $foreman::puppet_home,
    }
  }

  include foreman::config::database

}
