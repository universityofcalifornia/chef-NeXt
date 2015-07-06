name 'next'
license 'BSD'
version '1.0.2'
maintainer 'Eric Bollens'
maintainer_email 'eric@eb.io'

recipe 'next::app', 'Installs, configures and runs the NeXt application'
recipe 'next::https_rewrite', 'Sets a redirect to HTTPS based on port rules'
recipe 'next::iptables', 'Sets IP tables rules per NeXt-namespaced attribute'
recipe 'next::mysql', 'Defines an initial MySQL root password'
recipe 'next::mysql_client', 'Wrapper for mysql::client with NeXt-defined MySQL root password'
recipe 'next::mysql_service', 'Wrapper for mysql::server with NeXt-defined MySQL root password'

depends 'apache2'
depends 'database'
depends 'iptables'
depends 'mysql'
depends 'openssl'
depends 'ark'