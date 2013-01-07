class foreman::service::disabled inherits foreman::service {

  Service['foreman'] {
    enable => false,
    ensure => 'stopped',
  }

}
