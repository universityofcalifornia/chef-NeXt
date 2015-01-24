node['next']['https_rewrite'].each do |name, rewrite|

  enabled = rewrite['enabled'] ? rewrite['enabled'] : true

  web_app "https_rewrite-#{name}" do
    template "https_rewrite.conf.erb"
    from_port rewrite['from']
    enable enabled
  end

end