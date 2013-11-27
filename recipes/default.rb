
attr = node['ssh_userkey']

if attr
  ssh_userkey attr['user'] do
    home attr['home'] if attr['home']
    only_if { attr['user'] }
  end
end

