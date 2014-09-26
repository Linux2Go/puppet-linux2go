Vagrant.configure("2") do |config|

  config.vm.box      = 'ubuntu/trusty64'

  config.vm.provider "lxc" do |v, override|
    override.vm.box = "fgrehm/trusty64-lxc"
  end

  {
    :chlorine => 20,
  }.each do |node_name, number|

    config.vm.define(node_name) do |config|

      config.vm.synced_folder("hiera/", '/etc/puppet/hiera/')
      config.vm.synced_folder("modules/", '/etc/puppet/modules')
	  config.vm.synced_folder("manifests/", "/etc/puppet/manifests")

      config.vm.host_name = "#{node_name}.vagrant.linux2go.dk"

      config.vm.provision 'shell', :inline =>
        'test -e puppet.deb && exit 0; release=$(lsb_release -cs); wget -O puppet.deb http://apt.puppetlabs.com/puppetlabs-release-${release}.deb; dpkg -i puppet.deb; apt-get update; apt-get install -y puppet-common=3.6.2-1puppetlabs1'

      config.vm.provision 'shell', :inline =>
         'puppet apply --debug /etc/puppet/manifests/site.pp'
    end
  end
end
