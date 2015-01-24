::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default['next']['mysql']['root']['host'] = '127.0.0.1'
set['next']['mysql']['root']['username'] = 'root'
set_unless['next']['mysql']['root']['password'] = secure_password