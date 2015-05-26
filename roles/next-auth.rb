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
  'shibboleth-sp' => {
    'configuration' => {
      'application_defaults' => {
        'REMOTE_USER' => 'SHIB_eduPersonPrincipalName',
        'session_initiator' => {
          'entityID' => 'urn:mace:incommon:ucla.edu' # TODO: replace with real initiator
        }
      }
    },
    'attribute-map' => {
      'urn:oid:1.3.6.1.4.1.5923.1.1.1.6' => {
        'id' => 'SHIB_EPPN',
        'decoder' => {
          'type' => 'ScopedAttributeDecoder'
        }
      },
      'urn:mace:dir:attribute-def:eduPersonAffiliation' => {
        'id' => 'SHIB_EDU_PERSON_AFFILIATION',
        'decoder' => {
          'caseSensitive' => 'false'
        }
      },
      'urn:oid:1.3.6.1.4.1.5923.1.1.1.10' => {
        'id' => 'SHIB_EDUPERSONTARGETEDID',
        'decoder' => {
            'type' => 'NameIDAttributeDecoder',
            'formatter' => '$Name'
        }
      },
      'urn:mace:dir:attribute-def:givenName' => 'SHIB_GIVEN_NAME',
      'urn:mace:dir:attribute-def:sn' => 'SHIB_SN',
      'urn:mace:dir:attribute-def:mail' => 'SHIB_MAIL'
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