# Installs CKAN on 10.04 
class ckan( $version = '1.7') {

  package { 'ckan-req':
    name => [
      'postgresql-8.4',
      'solr-jetty',
    ],
      ensure => installed
  }

  package { 'ckan':
    ensure => installed,
    require => File["ckan.list", "ckan.key"]
  }

  file { "ckan.list":
    path  => "/etc/apt/sources.list.d/ckan.list",
    content => template("ckan/ckan.list.erb"),
    ensure => present;
  }

  file { "/etc/apt/keys.d":
    ensure => "directory",
    mode => 0755,
    owner => root, 
    group => root,
  }

  file { "ckan.key":
    path  => "/etc/apt/keys.d/ckan.key",
    owner => root,
    group => root,
    mode => 644,
    source => "puppet:///modules/ckan/debian.ckan.key",
  }

  # Should probably use an apt manager: http://drupalcode.org/project/drush-vagrant.git/tree/refs/heads/7.x-2.x:/lib/puppet-modules/apt
  exec { "apt_key_add_${name}":
    command => "apt-key add /etc/apt/keys.d/ckan.key",
    path => "/bin:/usr/bin:/sbin:/usr/sbin",
    refreshonly => true,
    subscribe => File["/etc/apt/keys.d/ckan.key"],
    #notify => Exec['update_apt'];
  }
}
