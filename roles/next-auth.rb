name          "next-auth"
description   "NeXt Shibboleth-OAuth2 authorization proxy"

run_list([
  'recipe[apache2]',
  'recipe[apache2::mod_rewrite]',
  'recipe[apache2::mod_ssl]',
  'recipe[next::iptables]'
])

default_attributes({
  'next' => {
    'iptables' => {
      'public' => {
        'tcp' => [8443]
      }
    }
  }
})