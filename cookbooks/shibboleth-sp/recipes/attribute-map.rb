include_recipe "shibboleth-sp::package"

template '/etc/shibboleth/attribute-map.xml' do
  source 'attribute-map.xml.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[shibd]', :delayed
  notifies :restart, 'service[apache2]', :delayed
end