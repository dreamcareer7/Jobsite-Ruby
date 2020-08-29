## Muqawiloon

### Dependencies

- Virtualbox
- Vagrant
- The [vagrant-rsync-back](https://github.com/smerrill/vagrant-rsync-back) plugin. To install, simply run `vagrant plugin install vagrant-rsync-back` after installing Vagrant

### Initial setup

This project uses Vagrant with Virtualbox to easily create and configure an easily-reproductible development environment. Since most dependencies are downloaded within the guest VM, the only dependencies needed on the host machine are the ones mentioned above. To get started, simply provision the VM with the following command:

```bash
vagrant up # Launch the Vagrant VM. This will also provision the VM the first time it is run.
vagrant ssh # SSH into the VM
bundle # Install rails and all dependencies
bundle exec rails db:create # Create the dev database
RAILS_ENV=test bundle exec rails db:create # Create the test database
```

### Servers and daemons

Although Vagrant takes care of the initial environment setup, some of the servers and daemons still have to be launched manually from time to time.

```bash
bundle exec rails s # Rails app server
sudo redis-server /etc/redis/6379.conf # Redis
bundle exec sidekiq -C config/sidekiq.yml -d -L ~/log/sidekiq.log # Sidekiq background workers
nohup bundle exec guard >/dev/null 2>&1 & # Guard for livereloading
```

### Syncing files with the VM

To automatically sync your project's files in sync with the VM, you need to keep the following command running:

```bash
vagrant rsync-auto
```

When files change directly in the VM and have to be propagated back to the host machine (such as when using `rails g` to generate files or when `schema.rb` is changed after a migration), run the following command:

```bash
vagrant rsync-back
```
