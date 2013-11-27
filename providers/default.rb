
action :create do
  username = new_resource.name
  home     = new_resource.home || "/home/#{username}"
  seckey   = "#{home}/.ssh/id_rsa"
  pubkey   = "#{seckey}.pub"

  unless ::File.exist?(pubkey)

    directory "#{home}/.ssh" do
      mode  0700
      owner username
      group username
    end

    execute "generate-ssh-key-for-#{username}" do
      user username
      creates pubkey
      command "ssh-keygen -t rsa -q -f #{seckey} -P \"\""
      notifies :run, "ruby_block[print-public-key]"
    end

    ruby_block "print-public-key" do
      block do
        Chef::Log.info ::File.read(pubkey)
      end
      action :nothing
    end

    new_resource.updated_by_last_action(true) # notify when updated

  end
end
