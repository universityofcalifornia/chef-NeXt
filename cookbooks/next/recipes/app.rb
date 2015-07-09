# Helpful attribute extractions
app = node['next']['app']
path = app['path']
db = app['database'][app['rails_env']]

# Process commands (TODO: swap this to init.d scripts)
signature = "thin server"
start_cmd = "bundle install --without=development test && LD_LIBRARY_PATH=/usr/local/lib/ RAILS_ENV=#{app['rails_env']} bundle exec thin start --ssl --ssl-disable-verify -p 443 -d"
stop_cmd = "ps aux | grep '#{signature}' | grep -v 'grep' && kill $(ps aux | grep '#{signature}' | grep -v 'grep' | awk '{print $2}')"

# NeXt needs imagemagick, but rhel6 doesn't have imagemagick-devel
ark 'ImageMagick' do
  url  'http://www.imagemagick.org/download/ImageMagick.tar.gz'
  version '6.9.1'
  checksum 'db3ad86764fdf9cfd935c6b9ae335bb82294b498e3819a4925410c221140b624'
  action :install_with_make
end

# Sync the repository with the configured revision
git path do
  repository app['repository']
  revision app['revision']
  action :sync
  notifies :run, "execute[#{path} bundle install]", :immediately
  notifies :run, "execute[#{path} npm install]", :immediately
  notifies :run, "execute[#{path} bundle exec blocks build]", :immediately
  notifies :run, "execute[#{path} rake db:migrate]", :delayed
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

file "#{path}/config/database.yml" do
  content JSON.parse(app['database'].to_json).to_yaml
  notifies :run, "execute[#{path} rake db:migrate]", :immediately
  notifies :run, "execute[#{path} restart server]", :delayed
end

file "#{path}/config/environments/#{app['rails_env']}.yml" do
  content JSON.parse(app['environment'].to_json).to_yaml
  notifies :run, "execute[#{path} restart server]", :delayed
end

file "#{path}/config/secrets.yml" do
  content({ app['rails_env'] => { 'secret_key_base' => app['secret_key_base'] } }.to_yaml)
  notifies :run, "execute[#{path} restart server]", :delayed
end

execute "#{path} enable server" do
  command 'echo enabling server'
  not_if "ps aux | grep '#{signature}' | grep -v 'grep'"
  notifies :run, "execute[#{path} start server]", :delayed
end

# TRIGGERED ACTIONS
# these definitions don't get applied unless triggered by some other definition

execute "#{path} bundle install" do
  cwd path
  command 'LD_LIBRARY_PATH=/usr/local/lib/ bundle install --without=development test'
  environment('PATH' => "#{ENV['PATH']}:/usr/local/bin", 'PKG_CONFIG_PATH' => '/usr/local/lib/pkgconfig')
  action :nothing
end

execute "#{path} npm install" do
  cwd path
  command 'npm install'
  action :nothing
end

execute "#{path} bundle exec blocks build" do
  cwd path
  command 'LD_LIBRARY_PATH=/usr/local/lib/ bundle exec blocks build'
  action :nothing
end

execute "#{path} rake db:migrate" do
  cwd path
  command "LD_LIBRARY_PATH=/usr/local/lib/ bundle exec rake db:migrate RAILS_ENV=#{app['rails_env']}"
  action :nothing
end

execute "#{path} restart server" do
  cwd path
  command "#{stop_cmd}; #{start_cmd}"
  environment('PATH' => "#{ENV['PATH']}:/usr/local/bin", 'PKG_CONFIG_PATH' => '/usr/local/lib/pkgconfig')
  action :nothing
end

execute "#{path} start server" do
  command 'echo triggering restart of server'
  notifies :run, "execute[#{path} restart server]", :immediately
  action :nothing
end

execute "#{path} stop server" do
  cwd path
  command stop_cmd
  action :nothing
end