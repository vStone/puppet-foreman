# = Class: foreman::config::enc
#
# Configure foreman as external node classifier.
#
class foreman::config::enc {
  require foreman::params

  file { '/etc/puppet/node.rb':
    content => template('foreman/external_node.rb.erb'),
    mode    => '0550',
    owner   => 'puppet',
    group   => 'puppet',
  }
  file { "${foreman::params::puppet_home}/yaml":
    ensure  => directory,
    recurse => true,
    mode    => '0640',
    owner   => 'puppet',
    group   => 'puppet',
  }
  file { "${foreman::params::puppet_home}/yaml/foreman":
    ensure  => directory,
    mode    => '0640',
    owner   => 'puppet',
    group   => 'puppet',
  }
}
