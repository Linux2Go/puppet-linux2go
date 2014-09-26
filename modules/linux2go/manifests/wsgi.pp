class linux2go::wsgi {
  file { '/srv/apps':
    ensure => 'directory'
  }

  class { 'nginx': }

  package { ["git", "python-virtualenv"]:
    ensure => 'installed'
  }
}
