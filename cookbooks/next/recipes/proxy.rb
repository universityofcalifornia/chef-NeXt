# sets apache2 as a reverse proxy for next app and shib bits
  web_app "ucnext" do
    template "proxy_next.conf.erb"
    next_port node['next']['app']['port']
  end