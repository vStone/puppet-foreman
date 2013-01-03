class foreman::config::reports {

  cron { 'expire_old_reports':
    command => "(cd ${foreman::app_root} && rake reports:expire)",
    minute  => '30',
    hour    => '7',
  }

  cron { 'daily summary':
    command => "(cd ${foreman::app_root} && rake reports:summarize)",
    minute  => '31',
    hour    => '7',
  }


  exec { 'foreman-config-reports-create-dir':
    command => "/bin/mkdir -p ${puppet_basedir}/reports",
    creates => "${puppet_basedir}/reports"
  }
  file {"${puppet_basedir}/reports/foreman.rb":
    mode     => '0444',
    owner    => 'puppet',
    group    => 'puppet',
    content  => template('foreman/foreman-report.rb.erb'),
    require  => [
      Exec['foreman-config-reports-create-dir'],
      Class['::puppet::server::install']
    ],
  }

}
