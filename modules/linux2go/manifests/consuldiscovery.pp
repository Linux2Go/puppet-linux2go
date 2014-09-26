class linux2go::consuldiscovery(
  $hostname = "consuldiscovery.linux2go.dk",
  $datacenter = 'rax-dfw'
) {
  linux2go::wsgi::app { "consuldiscovery":
    git_url       => "https://github.com/sorenh/consuldiscovery.git",
	git_branch    => "master",
	app           => "consuldiscovery:app",
	internal_port => 12345,
	hostname      => $hostname,
  }

  class { 'consul':
    version => '0.4.0',
    config_hash => {
      'datacenter' => 'rax-dfw',
      'data_dir'   => '/var/lib/consul',
      'log_level'  => 'INFO',
      'server'     => true,
	  'bootstrap_expect' => 1 + 0,
	  'domain'     => $hostname,
	}
  }
  include dnsmasq

  dnsmasq::conf { 'consuldiscovery':
    ensure  => present,
    content => "server=/${hostname}/127.0.0.1#8600",
  }
}
