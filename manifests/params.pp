class foreman::params {

  # Basic configurations
  $foreman_url  = "https://${::fqdn}"
  # Should foreman act as an external node classifier (manage puppet class
  # assignments)
  $enc          = true
  # Should foreman receive reports from puppet
  $reports      = true
  # Should foreman recive facts from puppet
  $facts        = true
  # Do you use storeconfig (and run foreman on the same database) ? (note: not
  # required)
  $storeconfigs = false
  # should foreman manage host provisioning as well
  $unattended   = true
  # Enable users authentication (default user:admin pw:changeme)
  $authentication = false
  # configure foreman via apache and passenger
  $passenger    = true
  # force SSL (note: requires passenger)
  $ssl          = true

# Advance configurations - no need to change anything here by default
  # if set to true, no repo will be added by this module, letting you to
  # set it to some custom location.
  $custom_repo = false
  # this can be stable, rc, or nightly
  $repo        = 'stable'
  $railspath   = '/usr/share'
  $app_root    = "${railspath}/foreman"
  $user        = 'foreman'
  $environment = 'production'

  $database_settings = {
    'adapter'  => 'sqlite3',
    'database' => 'db/production.sqlite3',
    'pool'     => 5,
    'timeout'  => 5000,
  }
  #  $use_sqlite        = true

  # OS specific paths
  case $::operatingsystem {
    redhat,centos,fedora,Scientific: {
      $puppet_basedir  = '/usr/lib/ruby/site_ruby/1.8/puppet'
      $apache_conf_dir = '/etc/httpd/conf.d'
      $osmajor = regsubst($::operatingsystemrelease, '\..*', '')
      if $::operatingsystem == "Fedora" {
        $yumcode = "f${osmajor}"
      } else {
        $yumcode = "el${osmajor}"
      }
    }
    Debian,Ubuntu: {
      $puppet_basedir  = '/usr/lib/ruby/vendor_ruby/puppet'
      $apache_conf_dir = '/etc/apache2/conf.d'
    }
    default:              {
      $puppet_basedir  = '/usr/lib/ruby/1.8/puppet'
      $apache_conf_dir = '/etc/apache2/conf.d/foreman.conf'
    }
  }
  $puppet_home = '/var/lib/puppet'
}
