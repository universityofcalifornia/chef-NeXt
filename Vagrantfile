# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = 'chef/centos-6.5'
  config.vm.box_url = 'https://vagrantcloud.com/chef/boxes/centos-6.5/versions/1/providers/virtualbox.box'

  config.vm.define 'next' do |box|

    box.vm.hostname = 'next'
    box.vm.network 'private_network', ip: '192.168.0.100'
    box.vm.provision 'shell', path: 'scripts/bootstrap.sh'

    box.vm.provision 'chef_solo' do |chef|

      chef.cookbooks_path = ['cookbooks', 'vendor_cookbooks']
      chef.data_bags_path = 'data_bags'
      chef.environments_path = 'environments'
      chef.roles_path = 'roles'

      chef.environment = 'local'

      chef.add_role 'foundation'

    end

  end

end