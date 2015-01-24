::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default['next']['app']['path'] = '/var/www/app'
default['next']['app']['repository'] = 'https://github.com/universityofcalifornia/NeXt.git'
default['next']['app']['revision'] = 'master'
default['next']['app']['rails_env'] = 'production'
set_unless['next']['app']['secret_key_base'] = secure_password

default['next']['app']['database']['production']['adapter'] = 'mysql2'
default['next']['app']['database']['production']['encoding'] = 'utf8'
default['next']['app']['database']['production']['host'] = '127.0.0.1'
default['next']['app']['database']['production']['username'] = 'app'
set_unless['next']['app']['database']['production']['password'] = secure_password
default['next']['app']['database']['production']['database'] = 'app'

default['next']['app']['environment']['oauth2']['provider']['shibboleth']['enabled'] = true
default['next']['app']['environment']['oauth2']['provider']['shibboleth']['key'] = 'next'
set_unless['next']['app']['environment']['oauth2']['provider']['shibboleth']['secret'] = secure_password
default['next']['app']['environment']['oauth2']['provider']['shibboleth']['properties']['authorize_url'] = '/oauth2/authorize'
default['next']['app']['environment']['oauth2']['provider']['shibboleth']['properties']['token_url'] = '/oauth2/access_token'
default['next']['app']['environment']['oauth2']['provider']['shibboleth']['routes']['get_user'] = '/oauth2/user'