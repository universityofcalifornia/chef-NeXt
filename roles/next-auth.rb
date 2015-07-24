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
      'sp' => 'ucnext'
    #  'application_defaults' => {
    #    'REMOTE_USER' => 'SHIB_eduPersonPrincipalName',
    #    'session_initiator' => {
    #      'entityID' => 'urn:mace:incommon:ucla.edu' # TODO: replace with real initiator
    #    }
    #  }
    },
    'attribute-map' => {
      'urn:oid:1.3.6.1.4.1.5923.1.1.1.6' => {
        'id' => 'SHIB_EPPN',
        'decoder' => {
          'type' => 'ScopedAttributeDecoder'
        }
      },
      'urn:oid:1.3.6.1.4.1.5923.1.1.1.10' => 'SHIB_EDUPERSONTARGETEDID',
      'urn:oid:1.3.6.1.4.1.5923.1.1.1.7' => 'entitlement',
      'urn:oid:1.3.6.1.4.1.5923.1.1.1.1' => {
        'id' => 'SHIB_EDU_PERSON_AFFILIATION',
        'decoder' => {
          'type' => 'StringAttributeDecoder',
          'caseSensitive' => 'false'
        }
      },
      'urn:oid:1.3.6.1.4.1.5923.1.1.1.9' => {
        'id' => 'scopedAffiliation',
        'decoder' => {
          'type' => 'ScopedAttributeDecoder',
          'caseSensitive' => 'false'
        }
      },
      'urn:oid:2.5.4.4' => 'SHIB_SN',
      'urn:oid:2.5.4.42' => "SHIB_GIVEN_NAME",
      'urn:oid:2.16.840.1.113730.3.1.241' => 'displayName',
      'urn:oid:0.9.2342.19200300.100.1.3' => 'SHIB_MAIL',
      'urn:oid:2.16.840.1.113916.1.1.4.1' => 'UCnetID',
      'urn:oid:2.16.840.1.113916.1.1.5' => 'UCTrustAssurance'
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