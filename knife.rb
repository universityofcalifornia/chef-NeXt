current_dir = File.dirname(__FILE__)
user = ENV['NEXT_OPSCODE_USER'] || ENV['USER']
org = 'ucnext'

node_name                user
client_key               "#{ENV['HOME']}/.chef/#{user}.pem"
validation_client_name   "#{org}-validator"
validation_key           "#{ENV['HOME']}/.chef/#{org}-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/#{org}"
syntax_check_cache_path  "#{ENV['HOME']}/.chef/syntax_check_cache"
cookbook_path            ["#{current_dir}/cookbooks", "#{current_dir}/vendor_cookbooks"]

knife[:digital_ocean_client_id] = ENV['DIGITAL_OCEAN_CLIENT_ID']
knife[:digital_ocean_api_key] = ENV['DIGITAL_OCEAN_API_KEY']