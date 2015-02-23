_ENV_ = {
  hostname: 'ucnext.org',
  alert_email_addresses: [
    'ebollens@oit.ucla.edu'
  ]
}

name          'preview'
description   'Preview environment'

default_attributes({
  'next' => {
    'app' => {
      environment: {
        oauth2: {
          provider: {
            shibboleth: {
              properties: {
                site: "http://#{_ENV_[:hostname]}:8443",
                authorize_url: '/oauth2/test-authorize'
              }
            }
          }
        }
      },
      seed: true
    },
    'auth' => {
      'server_name' => _ENV_[:hostname],
      'htaccess' => {
        'shibboleth-stub' => {
          '_test' => true,
          'eppn' => 'example@localhost',
          'sn' => 'User',
          'given_name' => 'Example',
          'mail' => 'example@mail.localhost',
          'edu_person_affiliation' => 'staff@localhost;employee@localhost'
        }
      },
      'seeds' => {
        'clients' => {
          'next' => {
            'name' => 'NeXt',
            'endpoints' => [
                "https://#{_ENV_[:hostname]}/auth/oauth2/shibboleth"
            ]
          }
        }
      }
    }
  },
  'monit' => {
    'config' => {
    'subscribers' => _ENV_[:alert_email_addresses].map(){ |email|
        { 'name' => email, 'subscriptions' => %w( nonexist timeout resource icmp connection ) }
      }
    }
  }
})