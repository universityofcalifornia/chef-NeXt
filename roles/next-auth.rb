name          "next-auth"
description   "NeXt Shibboleth-OAuth2 authorization proxy"

run_list([
  'recipe[apache2]',
  'recipe[apache2::mod_rewrite]',
  'recipe[apache2::mod_ssl]',
  'recipe[apache2::mod_php5]',
  'recipe[next::mysql_client]',
  'recipe[next::iptables]',
  'recipe[next::auth]'
])

default_attributes({
  'next' => {
    'auth' => {
      'revision' => '1.0.05-beta',
      'server_port' => 8443
    },
    'iptables' => {
      'public' => {
        'tcp' => [ 8443 ]
      }
    }
  },
  'php' => {
    'packages' => [
      'php-mbstring',
      'php-mcrypt',
      'php-mysql'
    ]
  }
})

override_attributes({
  'apache' => {
    'listen_ports' => [ 8443 ]
  }
})