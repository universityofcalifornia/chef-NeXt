include_recipe "shibboleth-sp::package"
include_recipe "shibboleth-sp::attribute-map"

template '/etc/shibboleth/shibboleth2.xml' do
  source 'shibboleth2.xml.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[shibd]', :delayed
  notifies :restart, 'service[apache2]', :delayed
end

unless node['shibboleth-sp']['configuration']['sp'].nil?

  sp = data_bag_item('shibboleth-sp', node['shibboleth-sp']['configuration']['sp'])

  file '/etc/shibboleth/sp-cert.pem' do
    content sp['cert']
    owner 'shibd'
    group 'root'
    mode '0600'
    notifies :restart, 'service[shibd]', :delayed
    notifies :restart, 'service[apache2]', :delayed
  end

  file '/etc/shibboleth/sp-key.pem' do
    content sp['key']
    owner 'shibd'
    group 'root'
    mode '0600'
    notifies :restart, 'service[shibd]', :delayed
    notifies :restart, 'service[apache2]', :delayed
  end

end
