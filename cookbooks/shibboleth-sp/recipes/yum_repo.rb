yum_repository 'security_shibboleth' do
  description 'Shibboleth (CentOS_CentOS-6)'
  baseurl 'http://download.opensuse.org/repositories/security:/shibboleth/CentOS_CentOS-6/'
  gpgkey 'http://download.opensuse.org/repositories/security:/shibboleth/CentOS_CentOS-6/repodata/repomd.xml.key'
  enabled false
  action :create
end