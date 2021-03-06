# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #config.vm.box = 'chef/centos-6.5'
  #config.vm.box_url = 'https://vagrantcloud.com/chef/boxes/centos-6.5/versions/1/providers/virtualbox.box'

  config.vm.box = 'chef/centos-6.5'
  config.vm.box_url = 'https://atlas.hashicorp.com/chef/boxes/centos-6.5'

  config.vm.provider "virtualbox" do |v|
      v.gui = true
  end
  

  config.vm.define 'next' do |box|

    box.vm.hostname = 'next'
    box.vm.network 'private_network', ip: '192.168.1.100'
    box.vm.provision 'shell', path: 'scripts/bootstrap.sh'

    box.vm.provision 'chef_solo' do |chef|

      # Assign node variables that would otherwise be defined via node.set_unless for Chef server / hosted chef
      chef.json = {
        next: {
          app: {
            server_name: '192.168.1.100',
            database: {
              production: {
                password: 'app'
              }
            },
            environment: {
              oauth2: {
                provider: {
                  shibboleth: {
                    secret: 'txen',
                    properties: {
                      site: 'http://192.168.1.100:8443'
                    }
                  }
                }
              }
            },
            secret_key_base: 'insecure'
          },
          auth: {
            server_name: '192.168.1.100',
            database: {
              connections: {
                mysql: {
                  password: 'auth'
                }
              }
            },
            seeds: {
              clients: {
                'next' => {
                  'secret' => 'txen',
                  'endpoints' => [
                      "https://192.168.1.100/auth/oauth2/shibboleth"
                  ]
                }
              }
            }
          },
          mysql: {
            root: {
              password: 'root'
            }
          }
        }
      }

      chef.cookbooks_path = ['cookbooks', 'vendor_cookbooks']
      chef.data_bags_path = 'data_bags'
      chef.environments_path = 'environments'
      chef.roles_path = 'roles'

      chef.environment = 'local'

      chef.add_role 'foundation'
      chef.add_recipe 'chef-solo-search' # don't use this with Chef server / hosted chef
      chef.add_role 'next-database'
      chef.add_role 'next-app'
      chef.add_role 'next-auth'

      # Only uncomment to test Shibboleth setup (SPs don't like localhost)
      # chef.add_recipe 'shibboleth-sp::configure'
      # chef.add_recipe 'shibboleth-sp::service'
      # chef.add_recipe 'shibboleth-sp::apache2'

    end

  end

end