_ENV_ = {
  alert_email_addresses: [ ]
}

name          'local'
description   'Local development environment'

default_attributes({
  'monit' => {
    'config' => {
    'subscribers' => _ENV_[:alert_email_addresses].map(){ |email|
        { 'name' => email, 'subscriptions' => %w( nonexist timeout resource icmp connection ) }
      }
    }
  }
})