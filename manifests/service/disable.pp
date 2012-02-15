# = Class: foreman::service::disable
#
# Description of foreman::service::disabled
#
#
class foreman::service::disable inherits foreman::service {

  Service['foreman'] {
    ensure => 'stopped',
    enable => false,
  }

}

