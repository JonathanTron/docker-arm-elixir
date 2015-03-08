# -*- mode: ruby -*-
# vi: set ft=ruby :
ROOT = File.dirname(File.absolute_path(__FILE__))

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

# Default env properties which can be overridden
# Example overrides:
BASE_BOX_URL          = ENV['BASE_BOX_URL']    || 'https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/'
VAGRANT_BOX_URL       = ENV['VAGRANT_BOX_URL'] || BASE_BOX_URL + 'ubuntu-14.04-amd64-vbox.box'

$script = <<SCRIPT
wget -q -O - https://get.docker.io/gpg | apt-key add -
echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-get update -qq
apt-get install -q -y --force-yes lxc-docker qemu-user-static
usermod -a -G docker vagrant
docker version
su - vagrant -c 'echo alias d=docker >> ~/.bash_aliases'
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'phusion-open-ubuntu-14.04-amd64'
  config.vm.box_url = VAGRANT_BOX_URL
  config.ssh.forward_agent = true

  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    config.vm.provision :shell, :inline => $script
  end
end
