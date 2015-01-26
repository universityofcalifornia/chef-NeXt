_ENV_ = {

  alert_email_addresses: [ ]

}

name          'local'
description   'Local development environment'

default_attributes({
  'next' => {
    'auth' => {
      'htaccess' => {
        'shibboleth-stub' => {
          'eppn' => 'joebruin@ucla.edu',
          'sn' => 'Bruin',
          'given_name' => 'Jane',
          'mail' => 'janebruin@ucla.edu',
          'edu_person_affiliation' => 'staff@ucla.edu;employee@ucla.edu'
        }
      },
      'seeds' => {
        'clients' => {
          'next' => {
            'name' => 'NeXt'
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