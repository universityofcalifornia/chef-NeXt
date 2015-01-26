name          "next-app"
description   "NeXt app node"

run_list([
  'recipe[apache2]',
  'recipe[apache2::mod_rewrite]',
  'recipe[next::mysql_client]',
  'recipe[next::iptables]',
  'recipe[next::https_rewrite]',
  'recipe[next::app]'
])

default_attributes({
  'next' => {
    'app' => {
      'server_port' => 443,
      'environment' => {
        'oauth2' => {
          'provider' => {
            'shibboleth' => {
              'enabled' => true
            }
          }
        }
      }
    },
    'iptables' => {
      'public' => {
        'tcp' => [80, 443]
      }
    },
    'https_rewrite' => {
      'http' => { 'from' => 80 }
    }
  },
  'packages' => [
    'sqlite-devel'
  ]
})

override_attributes({
  'apache' => {
    'listen_ports' => [ 80 ]
  }
})