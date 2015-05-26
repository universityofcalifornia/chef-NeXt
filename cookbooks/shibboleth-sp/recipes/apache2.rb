include_recipe "shibboleth-sp::package"

apache_conf 'shib' do
  enable true
  notifies :restart, 'service[apache2]', :delayed
end