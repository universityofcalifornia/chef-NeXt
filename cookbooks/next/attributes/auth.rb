::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default['next']['auth']['path'] = '/var/www/auth'
default['next']['auth']['repository'] = 'https://github.com/ebollens/shib-oauth2-bridge.git'
default['next']['auth']['revision'] = 'master'

default['next']['auth']['app']['debug'] = false
default['next']['auth']['database']['default'] = 'mysql'

default['next']['auth']['database']['connections']['mysql']['driver'] = 'mysql'
default['next']['auth']['database']['connections']['mysql']['charset'] = 'utf8'
default['next']['auth']['database']['connections']['mysql']['collation'] = 'utf8_unicode_ci'
default['next']['auth']['database']['connections']['mysql']['prefix'] = ''
default['next']['auth']['database']['connections']['mysql']['host'] = '127.0.0.1'
default['next']['auth']['database']['connections']['mysql']['port'] = 3306
default['next']['auth']['database']['connections']['mysql']['username'] = 'auth'
set_unless['next']['auth']['database']['connections']['mysql']['password'] = secure_password
default['next']['auth']['database']['connections']['mysql']['database'] = 'auth'