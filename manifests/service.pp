# = Class: foreman::service
#
# Setup the foreman service. Either standalone or through the use of passenger.
#
#
class foreman::service {

  require foreman::params

  case $foreman::params::passenger {
    true: {
      $service_ensure = 'stopped'
      $service_enable = false
    }
    default, false: {
      $service_ensure  = 'running'
      $service_enabled = true
    }
  }

  service {'foreman':
    ensure    => $service_ensure,
    enable    => $service_enabled,
    hasstatus => true,
  }
}
