## Development

Download Vagrant:

> https://www.vagrantup.com/downloads

Install plugins:

```
vagrant plugin install vagrant-omnibus
vagrant plugin install vagrant-vbox-snapshot
```

Install dependencies:

```
bundle
```

Pull vendor cookbooks:

```
bundle exec librarian-chef install
```

Launch the box:

```
vagrant up
```

Destroy the box:

```
vagrant destroy
```

Using SSH keys for one of the users in `data_bags/users`, connect with:

```
ssh USER@192.168.1.100
```

Consider updating `/etc/hosts` so you don't have to connect via local IP address.

## Deployment

### Knife

```
knife cookbook upload [name]
knife cookbook upload --all
```

```
knife role from file [filepath]
knife role from file roles/*
```

```
knife data bag from file [bagname] [filepath]
knife data bag from file --all
```

### Raw

With password:

```
knife bootstrap some.example.edu \
    --ssh-user root \
    --ssh-password 'some-password' \
    --node-name some-example \
    --run-list 'role[foundation]'
```

With pem file into EC2:

```
knife bootstrap some.example.edu \
    --ssh-user ec2-user
    --identity-file ~/.ssh/next.pem \
    --node-name some-example \
    --run-list 'role[foundation]'
    --sudo
```

Once this is done, log into the [Opscode Management console](https://manage.opscode.com) to assign additional roles to the node.