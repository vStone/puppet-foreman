# = Class: foreman::params
#
# Change foreman parameters.
#
# == Parameters:
#
# === Basic configuration
#
# $url::            Change the url on which you can access foreman.
#                   Defaults to "http://${::fqdn}": aka, the fully
#                   qualified domain name of this host.
#
# $enc::            Should foreman act as an external node classifier
#                   (manage puppet class assignments). Defaults to true.
#
# $reports::        Should foreman receive reports from puppet.
#                   Defaults to true.
#
# $facts::          Should foreman receive facts from puppet.
#                   Defaults to true.
#
# $storeconfigs::   Do you use storeconfig (and run foreman on the same
#                   database)? (note: this is not required)
#                   Defaults to false.
#
# $unattended::     Should foreman manage host provisioning as well?
#                   Defaults to true.
#
# $authentication:: Use user authentication (default user:admin pw: changeme)
#                   Defaults to false.
#
# $passenger::      Configure foreman via apache and passenger
#                   Defaults to true.
#
# $ssl::            Force SSL (requires passenger)
#                   Defaults to true.
#
# === Advanced configuration
#
# $use_testing::    Use the testing repository for the installation.
#                   Defaults to true.
#
# $railspath::      Rails Path. Defaults to '/usr/share'.
#
# $application_root:: Foreman application root folder.
#                     Defaults to <RAILSPATH>/foreman.
#
# $user::           User to run as. Defaults to 'foreman'.
#
# $environment::    Environment to use. Defaults to 'production'.
#
class foreman::params (
  $url            = undef,
  $enc            = true,
  $reports        = true,
  $facts          = true,
  $storeconfigs   = false,
  $unattended     = true,
  $authentication = false,
  $passenger      = true,
  $ssl            = true,
  $use_testing    = true,
  $railspath      = '/usr/share',
  $application_root = undef,
  $user           = 'foreman',
  $environment    = 'production'
) {

  # Basic configurations
  ## If there is no url defined, fallback to the default.
  $foreman_url = $url ? {
    undef   => "http://${::fqdn}",
    default => $url,
  }

  # Advance configurations - no need to change anything here by default
  ## If there is no application_root defined, Fallback to default.
  $app_root = $foreman::params::approot ? {
    undef   => "${railspath}/foreman",
    default => $foreman::params::approot,
  }

  # OS specific paths
  case $::operatingsystem {
    redhat,centos,fedora,Scientific: {
      $puppet_basedir  = '/usr/lib/ruby/site_ruby/1.8/puppet'
      $apache_conf_dir = '/etc/httpd/conf.d'
    }
    Debian,Ubuntu: {
      $puppet_basedir  = '/usr/lib/ruby/1.8/puppet'
      $apache_conf_dir = '/etc/apache2/conf.d'
    }
    default:              {
      $puppet_basedir  = '/usr/lib/ruby/1.8/puppet'
      $apache_conf_dir = '/etc/apache2/conf.d/foreman.conf'
    }
  }
  $puppet_home = '/var/lib/puppet'
}
