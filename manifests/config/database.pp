class foreman::config::database {

  file {'/etc/foreman/database.yml':
    ensure  => 'present',
    content => template("${module_name}/database.yml.erb"),
    require => [
      Package['foreman'],
      File['/etc/foreman/settings.yaml'],
    ],
    notify  => Exec['foreman_rake_db:migrate_refresh'],
  }

  exec {'foreman_rake_db:migrate_refresh':
    command     => 'rm /var/lib/foreman/db.migrated',
    onlyif      => 'test -f /var/lib/foreman/db.migrated',
    refreshonly => true,
    notify  => Exec['foreman_rake_db:migrate'],
  }

  exec {'foreman_rake_db:migrate':
    creates     => '/var/lib/foreman/db.migrated',
    command     => 'bundle exec rake db:migrate && date > /var/lib/foreman/db.migrated',
    environment => ["RAILS_ENV=${foreman::environment}"],
    cwd         => $::foreman::app_root,
    path        => ['/usr/bin','/bin'],
    require     => [
      File['/etc/foreman/database.yml'],
    ]
  }

}
