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
  $use_repo       = true,
  $use_testing    = true,
  $railspath      = '/usr/share',
  $application_root = undef,
  $user           = 'foreman',
  $environment    = 'production',
  $puppethome     = undef,
  $puppetbasedir  = undef
) {

  # Basic configurations
  ## If there is no url defined, fallback to the default.
  if $ssl { $uri = 'https://' } else { $uri = 'http://' }
  $foreman_url = $url ? {
    undef   => "${uri}${::fqdn}",
    default => $url,
  }

  # Advance configurations - no need to change anything here by default
  ## If there is no application_root defined, Fallback to default.
  $app_root = $application_root ? {
    undef   => "${railspath}/foreman",
    default => $application_root,
  }

  $puppet_basedir = $puppetbasedir ? {
    undef => $::operatingsystem ? {
      /(?i:redhat|centos|fedora|Scientific)/ => '/usr/lib/ruby/site_ruby/1.8/puppet',
      /(?i:Debian|Ubuntu)/                   => '/usr/lib/ruby/1.8/puppet',
      default                                => '/usr/lib/ruby/1.8/puppet',
    },
    default => $puppetbasedir,
  }

  $puppet_home =  $puppethome ? {
    undef   => '/var/lib/puppet',
    default => $puppethome,
  }

  $apache_conf_dir = $::operatingsystem ? {
    /(redhat|centos|fedora|Scientific)/ => '/etc/httpd/conf.d',
    /(Debian|Ubuntu)/                   => '/etc/apache2/conf.d',
    default                             => '/etc/apache2/conf.d/foreman.conf',
  }

}
