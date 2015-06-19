name          "next-app"
description   "NeXt app node"

run_list([
  'recipe[elasticsearch]',
  'recipe[apache2]',
  'recipe[apache2::mod_rewrite]',
  'recipe[next::mysql_client]',
  'recipe[next::iptables]',
  'recipe[next::https_rewrite]',
  'recipe[next::app]'
])

# last revision was 1.0.01-dev
# updated to 1.0.04-dev-54-gdb84464 on 20150608
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
      'revision' => '1.0.12-sgj_mod_gemfile_3',
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
    'sqlite-devel',
    'ImageMagick'
  ]
})

override_attributes({
  'apache' => {
    'listen_ports' => [ 80 ]
  }
})