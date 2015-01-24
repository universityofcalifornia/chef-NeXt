_ENV_ = {
  alert_email_addresses: [
    'ebollens@oit.ucla.edu'
  ]
}

name          'production'
description   'Production environment'

default_attributes({
  'monit' => {
    'config' => {
    'subscribers' => _ENV_[:alert_email_addresses].map(){ |email|
        { 'name' => email, 'subscriptions' => %w( nonexist timeout resource icmp connection ) }
      }
    }
  }
})