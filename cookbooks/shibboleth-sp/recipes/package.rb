include_recipe 'shibboleth-sp::yum_repo'

yum_package "shibboleth" do
  package_name "shibboleth.x86_64"
  options "--enablerepo=security_shibboleth"
  action :install
end

include_recipe "shibboleth-sp::service"