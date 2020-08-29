# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Use Ubuntu 14.04 Trusty Tahr 64-bit as our operating system
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider :virtualbox do |v|
    host = RbConfig::CONFIG["host_os"]

    # Configure the virtual machine to use half the system's RAM and all of its CPUs
    if host =~ /darwin/ # OS X
      # sysctl returns bytes, convert to MB
      v.memory = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 2
      v.cpus = `sysctl -n hw.ncpu`.to_i
    elsif host =~ /linux/ # Linux
      # meminfo returns kilobytes, convert to MB
      v.memory = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 2
      v.cpus = `nproc`.to_i
    end

    # Fix for Rails not autoreloading: https://github.com/rails/rails/issues/16678#issuecomment-113058925
    v.customize ["guestproperty", "set", :id, "--timesync-threshold", 5000]
  end

  # Forward the Rails server default port to the host
  config.vm.network :forwarded_port, guest: 3000, host: 3000 # App server
  config.vm.network :forwarded_port, guest: 9200, host: 9200 # Elasticsearch
  config.vm.network :forwarded_port, guest: 35729, host: 35729 # Livereload

  # Use Chef Solo to provision the VM
  config.vm.provision :chef_solo do |chef|
    chef.version = "12.10.40" # Temporary fix for https://github.com/chef/chef/issues/4948

    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe "apt"
    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::user"
    chef.add_recipe "rbenv::vagrant"
    chef.add_recipe "vim"
    chef.add_recipe "postgresql::client"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "elasticsearch"
    chef.add_recipe "java"
    chef.add_recipe "redisio"
    chef.add_recipe "imagemagick"
    chef.add_recipe "phantomjs"

    # Install Ruby 2.3.1 and Bundler
    # Set an empty root password for MySQL to make things simple
    chef.json = {
      ruby_build: {
        upgrade: true
      },
      rbenv: {
        user_installs: [{
          user: 'vagrant',
          rubies: ["2.3.1"],
          global: "2.3.1",
          gems: {
            "2.3.1" => [
              { name: "bundler" }
            ]
          }
        }]
      },
      elasticsearch: {
        version: '2.2.0'
      },
      postgresql: {
        version: "9.3",
        listen_address: "*",
        hba: [
          { method: "trust", address: "0.0.0.0/0" },
          { method: "trust", address: "::1/0" }
        ],
        password: {
          postgres: "password"
        }
      },
      java: {
        install_flavor: 'oracle',
        jdk_version: '7',
        oracle: {
          accept_oracle_download_terms: true
        }
      },
      nodejs: {
        npm_packages: [{
          name: 'bower'
        }]
      }
   }
  end

  # In addition to using Chef, we run custom provisioning commands
  config.vm.provision :shell, path: "bootstrap.sh"

  # Use rsync for shared folders (much faster)
  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  config.ssh.forward_agent = true
end
