name          "foundation-chef"
description   "Chef client configuration"

run_list [
  'recipe[chef-client::config]',
  'recipe[chef-client::service]',
  'recipe[chef-solo-search]'
]

default_attributes({
  'chef_client' => {
    'interval' => 600
  }
})