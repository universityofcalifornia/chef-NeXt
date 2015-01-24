include_recipe 'next::mysql'

mysql_service 'default' do
  initial_root_password node['next']['mysql']['root']['password']
  action [:create, :start]
end