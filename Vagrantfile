# -*- mode: ruby -*-
# vi: set ft=ruby :
ROOT = File.dirname(File.absolute_path(__FILE__))

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

# Default env properties which can be overridden
# Example overrides:
BASE_BOX_URL    = ENV['BASE_BOX_URL']    || 'https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/'
VAGRANT_BOX_URL = ENV['VAGRANT_BOX_URL'] || BASE_BOX_URL + 'ubuntu-14.04-amd64-vbox.box'
UBUNTU_MIRROR   = ENV['UBUNTU_MIRROR']   || 'eu.archive.ubuntu.com'

$script = <<SCRIPT
sed -i 's/us.archive.ubuntu.com/#{UBUNTU_MIRROR}/g' /etc/apt/sources.list
wget -q -O - https://get.docker.io/gpg | apt-key add -
echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-get update -qq
apt-get install -q -y --force-yes lxc-docker qemu-user-static
usermod -a -G docker vagrant
docker version
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'phusion-open-ubuntu-14.04-amd64'
  config.vm.box_url = VAGRANT_BOX_URL
  config.ssh.forward_agent = true
  config.vm.provider "virtualbox" do |v|
    host = RbConfig::CONFIG['host_os']
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # sorry Windows folks, I can't help you
      cpus = 2
      mem = 1024
    end
    v.cpus = [cpus, 4].min # Don't use more than 4 cpus
    v.memory = [mem, 2048].min # Don't use more than 2GB of RAM
  end
  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    config.vm.provision :shell, :inline => $script
  end
end
