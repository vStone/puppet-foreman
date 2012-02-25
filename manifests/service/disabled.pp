# = Class: foreman::service::disabled
#
# Description of foreman::service::disabled
#
#
class foreman::service::disabled inherits foreman::service {

  Service['foreman'] {
    ensure => 'stopped',
    enable => false,
  }

}

