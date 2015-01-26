::Chef::Node.send(:include, Opscode::OpenSSL::Password)

# Helpful attribute extractions
app = node['next']['auth']
path = app['path']
environment_name = 'deploy'
db = app['database']['connections']['mysql']

web_user = node['apache']['user']
web_group = node['apache']['group']


git path do
  repository app['repository']
  revision app['revision']
  action :sync
  notifies :run, "execute[#{path} composer download]", :immediately
  notifies :run, "execute[#{path} composer install]", :immediately
  notifies :run, "execute[#{path} composer dump-autoload]", :immediately
  notifies :run, "execute[#{path} php artisan migrate oauth package]", :delayed
  notifies :run, "execute[#{path} php artisan migrate]", :delayed
end

mysql_database db['database'] do
  connection node['next']['mysql']['root']
  action :create
end

mysql_database_user db['username'] do
  connection node['next']['mysql']['root']
  host db['host']
  password db['password']
  database_name db['database']
  privileges [:all]
  action :grant
end

[
  "#{path}/app/storage",
  "#{path}/app/storage/cache",
  "#{path}/app/storage/files",
  "#{path}/app/storage/logs",
  "#{path}/app/storage/meta",
  "#{path}/app/storage/sessions",
  "#{path}/app/storage/views"
].each do |path|
  directory path do
    owner web_user if web_user
    group web_group if web_group
    mode '0755'
  end
end

template "#{path}/bootstrap/start.php" do
  source "laravel-bootstrap.start.php.erb"
  owner 'root'
  group 'root'
  mode '0644'
  variables environment: environment_name
end

directory "#{path}/app/config/#{environment_name}" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template "#{path}/app/config/#{environment_name}/app.php" do
  source "laravel-config_file.php.erb"
  owner 'root'
  group 'root'
  mode '0644'
  variables vars: app['app']
end

template "#{path}/app/config/#{environment_name}/database.php" do
  source "laravel-config_file.php.erb"
  owner 'root'
  group 'root'
  mode '0644'
  variables vars: app['database']
  notifies :run, "execute[#{path} php artisan migrate oauth package]", :immediately
  notifies :run, "execute[#{path} php artisan migrate]", :immediately
end

template "#{path}/public/.htaccess" do
  source 'laravel-shib-oauth2-bridge-htaccess.erb'
  variables shibboleth_stub: (app['htaccess'] ? app['htaccess']['shibboleth-stub'] : nil)
end

web_app "laravel-auth" do
  template "laravel-web_app.conf.erb"
  docroot "#{path}/public"
  server_name app['server_name']
  server_port app['server_port']
  if app['ssl']
    ssl({
      cert_file: "/etc/pki/tls/certs/#{app['ssl']}.crt",
      cert_key_file: "/etc/pki/tls/private/#{app['ssl']}.key",
      ca_cert_file: "/etc/pki/tls/certs/ca-bundle-#{app['ssl']}.crt"
    })
  end
  enable enabled
  allow_override 'All'
end

if app['seeds']

  app['seeds']['clients'].keys.each do |key|
    unless app['seeds']['clients'][key]['secret']
      if key == 'next'
        node.set['next']['auth']['seeds']['clients'][key]['secret'] = node['next']['app']['environment']['oauth2']['provider']['shibboleth']['secret']
        execute "#{path} reload app environment per node attribute update" do
          command 'triggering reload of app environment config'
          notifies :run, "file[#{node['next']['app']['path']}/config/environments/#{node['next']['app']['rails_env']}.yml]", :immediately
          action :nothing
        end
      else
        node.set['next']['auth']['seeds']['clients'][key]['secret'] = secure_password
      end
    end
  end

  template "#{path}/app/database/seeds/DatabaseSeeder.php" do
    source "laravel-shib-oauth2-bridge-DatabaseSeeder.php.erb"
    variables seeds: app['seeds']
    not_if { ::File.exists?("#{path}/app/database/seeds/.seeded.php") }
    notifies :run, "execute[#{path} php artisan db:seed]", :immediately
  end

  execute "#{path} php artisan db:seed" do
    cwd path
    command "php artisan db:seed --env=deploy"
    notifies :create, "template[#{path}/app/database/seeds/.seeded.php]", :immediately
    notifies :run, "execute[revert #{path}/app/database/seeds/DatabaseSeeder.php]", :immediately
    action :nothing
  end

  template "#{path}/app/database/seeds/.seeded.php" do
    source "laravel-shib-oauth2-bridge-DatabaseSeeder.php.erb"
    variables seeds: app['seeds']
    action :nothing
  end

  execute "revert #{path}/app/database/seeds/DatabaseSeeder.php" do
    cwd path
    command "git checkout app/database/seeds/DatabaseSeeder.php"
    action :nothing
  end

end

# TRIGGERED ACTIONS
# these definitions don't get applied unless triggered by some other definition

execute "#{path} composer download" do
  cwd path
  command 'curl -sS https://getcomposer.org/installer | php'
  notifies :run, "execute[#{path} composer install]", :immediately
  action :nothing
end

execute "#{path} composer install" do
  cwd path
  command 'COMPOSER_HOME=\"/root/.composer\" php composer.phar install'
  action :nothing
end

execute "#{path} composer dump-autoload" do
  cwd path
  command 'COMPOSER_HOME=\"/root/.composer\" php composer.phar dump-autoload'
  action :nothing
end

execute "#{path} php artisan migrate oauth package" do
  cwd path
  command 'php artisan migrate --package="lucadegasperi/oauth2-server-laravel" --env=deploy'
  action :nothing
end

execute "#{path} php artisan migrate" do
  cwd path
  command 'php artisan migrate --env=deploy'
  action :nothing
end