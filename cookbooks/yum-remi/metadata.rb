name 'yum-remi'
license 'Proprietary'
version '1.0.0'
maintainer 'Eric Bollens'
maintainer_email 'eric@eb.io'

recipe 'yum-remi', 'Add (but do not enable) the remi repository'
recipe 'yum-remi::php55', 'Add (but do not enable) the remi/php55 repository'

supports 'centos'