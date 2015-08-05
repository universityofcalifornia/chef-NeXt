_ENV_ = {

  hostname: 'ucnext.org',

  alert_email_addresses: [
    'ebollens@oit.ucla.edu'
  ],

  auth_host: 'ucnext.org',
  auth_port: 443,
  shibboleth_entityID: 'ucnext'

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
                site: "https://#{_ENV_[:hostname]}",
                authorize_url: '/oauth2/authorize'
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
  'shibboleth-sp' => {
    'configuration' => {
      'sp' => 'ucnext',
      'application_defaults' => {
        'entityID' => _ENV_[:shibboleth_entityID],
        'homeURL' => "https://#{_ENV_[:auth_host]}:#{_ENV_[:auth_port]}"
      },
      'request_map' => [
        {
          'hostname' => _ENV_[:auth_host],
          'port' => _ENV_[:auth_port],
          'paths' => [
            '/oauth2/authorize'
          ]
        }
      ]
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