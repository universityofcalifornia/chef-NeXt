include_recipe 'next::mysql'

mysql_client 'default' do
  action :create
end