ssh_userkey Cookbook
===================
generate ssh key without passphrase for existing user

Requirements
------------

- ssh-keygen command

Usage
------------

```ruby
user 'foo'

ssh_userkey 'foo'
```

if home directory is not at '/home',

```ruby
ssh_userkey 'foo' do
  home '/Users/foo'
end
```

License and Authors
-------------------
MIT License

Authors: Aiming
