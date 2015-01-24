name          "foundation-chef"
description   "Chef client configuration"

run_list [
  'recipe[chef-client::config]',
  'recipe[chef-client::service]'
]

default_attributes({
  'chef_client' => {
    'interval' => 600
  },
  'rvm' => {
    'global_gems' => [
      { 'name' => 'chef', 'version' => '11.12.8' } # vagrant provision doesn't work if you don't install Chef in Ruby path
    ]
  }
})