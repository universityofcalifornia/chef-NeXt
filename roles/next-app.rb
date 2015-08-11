name          "next-app"
description   "NeXt app node"

run_list([
  'recipe[elasticsearch]',
  'recipe[apache2]',
  'recipe[apache2::mod_rewrite]',
  'recipe[next::mysql_client]',
  'recipe[next::iptables]',
  'recipe[next::app]'
])

# last revision was 1.0.13-sgj_mod_gemfile_3
# updated to 1.0.14 on 20150625
default_attributes({
  'elasticsearch' => {
    'version' => '1.3.4',
    'gateway' => {
      'type' => 'local'
    },
    'http' => {
      'port' => '9200'
    }
  },
  'next' => {
    'app' => {
      'revision' => '1.0.22',
      'server_port' => 5000,
      'environment' => {
        'oauth2' => {
          'provider' => {
            'shibboleth' => {
              'enabled' => true
            }
          }
        },
        'auth' => {
          'route' => '/auth/local/new',
          'allow_local' => true
        }
      }
    },
    'iptables' => {
      'public' => {
        'tcp' => [80, 443]
      }
    }
  },
  'packages' => [
    'sqlite-devel'
  ]
})

override_attributes({
  'apache' => {
    'listen_ports' => [ 8443 ]
  }
})
