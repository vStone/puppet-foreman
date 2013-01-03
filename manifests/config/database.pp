class foreman::config::database {

  file {'/etc/foreman/database.yml':
    ensure  => 'present',
    content => template("${module_name}/database.yml.erb"),
    require => [
      Package['foreman'],
      File['/etc/foreman/settings.yaml'],
    ],
    notify  => Exec['foreman_rake_db:migrate'],
  }

  exec {'foreman_rake_db:migrate':
    command     => 'bundle exec rake db:migrate',
    environment => ["RAILS_ENV=${foreman::environment}"],
    cwd         => $::foreman::app_root,
    path        => ['/usr/bin','/bin'],
    refreshonly => true,
    require     => [
      File['/etc/foreman/database.yml'],
    ]
  }

}
