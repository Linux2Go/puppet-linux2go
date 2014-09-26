define linux2go::wsgi::app(
  $git_url,
  $git_branch = 'master',
  $app,
  $internal_port,
  $hostname
) {
  include linux2go::wsgi

  file { "/srv/apps/$name":
    ensure => 'directory'
  }

  exec { "git-clone-wsgi-app-$name":
    command => "git clone -b $git_branch $git_url /srv/apps/$name/src",
	creates => "/srv/apps/$name/src",
	require => File["/srv/apps/$name"]
  } ->
  exec { "virtual-env-$name":
    command => "virtualenv venv && . venv/bin/activate && pip install gunicorn && pip install -r src/requirements.txt",
	cwd     => "/srv/apps/$name",
    creates => "/srv/apps/$name/venv",
	require => File["/srv/apps/$name"]
  }

  nginx::resource::upstream { "${name}_app":
    members => ["localhost:$internal_port"],
  }
  
  nginx::resource::vhost { "$hostname":
    proxy => "http://${name}_app"
  }

  file { "/etc/init/app-${name}.conf":
    content => template("linux2go/gunicorn.init.erb")
  } ->
  service { "app-${name}":
    ensure => "running"
  }

}
