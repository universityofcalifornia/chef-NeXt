default['shibboleth-sp']['configuration']['sp'] = nil
default['shibboleth-sp']['configuration']['request_map'] = []
default['shibboleth-sp']['configuration']['application_defaults']['entityID'] = 'https://yourshost.example.edu/shibboleth-sp'
default['shibboleth-sp']['configuration']['application_defaults']['homeURL'] = 'http://yourshost.example.edu/index.html'
default['shibboleth-sp']['configuration']['application_defaults']['REMOTE_USER'] = 'SHIBEDUPERSONPRINCIPALNAME'
default['shibboleth-sp']['configuration']['application_defaults']['session_initiator']['entityID'] = 'https://shib.example.edu/idp/shibboleth'