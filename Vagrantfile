# -*- mode: ruby -*-
# vi: set ft=ruby :
# SEE: https://github.com/patrickdlee/vagrant-examples/blob/master/example7/Vagrantfile
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!

domain  = 'local.pvt'
gateway = '192.168.100.2'
bridge  = 'en0: Wi-Fi (AirPort)'
nodes   = [
    {
        :hostname       => 'gateway',
        :box            => 'centos64', 
        :memory         => '256',
        :networks       => [
            {
                :iface_number   => 0,
                :network_type   => 'NAT',
            },
            {
                :iface_number   => 1,
                :network_type   => 'INTERNAL',
                :network_name   => 'publicnet',
                :ip             => '192.168.100.2',
            }
        ],
    },
    {
        :hostname       => 'san01',
        :box            => 'centos64',
        :memory         => '512',
        :networks       => [
            {
                :iface_number   => 0,
                :network_type   => 'NAT',
            },
            {
                :iface_number   => 1,
                :network_type   => 'INTERNAL',
                :network_name   => 'publicnet',
                :ip             => '192.168.100.10',
            },
            {
                :iface_number   => 2,
                :network_type   => 'INTERNAL',
                :network_name   => 'storagenet',
                :ip             => '192.168.150.10',
            },
        ] ,
    },
    {
        :hostname       => 'server01',
        :box            => 'centos64',
        :memory         => '512',
        :networks       => [
            {
                :iface_number   => 0,
                :network_type   => 'NAT',
            },
            {
                :iface_number   => 1,
                :network_type   => 'INTERNAL',
                :network_name   => 'publicnet',
                :ip             => '192.168.100.20',
            },
            {
                :iface_number   => 2,
                :network_type   => 'INTERNAL',
                :network_name   => 'storagenet',
                :ip             => '192.168.150.20',
            },
            {
                :iface_number   => 3,
                :network_type   => 'INTERNAL',
                :network_name   => 'servicenet',
                :ip             => '192.168.200.20',
            },
        ] ,
    },
    {
        :hostname       => 'server02',
        :box            => 'centos64',
        :memory         => '512',
        :networks       => [
            {
                :iface_number   => 0,
                :network_type   => 'NAT',
            },
            {
                :iface_number   => 1,
                :network_type   => 'INTERNAL',
                :network_name   => 'publicnet',
                :ip             => '192.168.100.30',
            },
            {
                :iface_number   => 2,
                :network_type   => 'INTERNAL',
                :network_name   => 'storagenet',
                :ip             => '192.168.150.30',
            },
            {
                :iface_number   => 3,
                :network_type   => 'INTERNAL',
                :network_name   => 'servicenet',
                :ip             => '192.168.200.30',
            },
        ] ,
    },
    {
        :hostname       => 'client01',
        :box            => 'centos64',
        :memory         => '512',
        :networks       => [
            {
                :iface_number   => 0,
                :network_type   => 'NAT',
            },
            {
                :iface_number   => 1,
                :network_type   => 'INTERNAL',
                :network_name   => 'publicnet',
                :ip             => '192.168.100.40',
            },
            {
                :iface_number   => 2,
                :network_type   => 'INTERNAL',
                :network_name   => 'servicenet',
                :ip             => '192.168.200.40',
            },
        ] ,
    },
]
    
Vagrant.configure("2")  do |config|
    nodes.each do |node|
        config.vm.define node[:hostname] do |node_config|
            node_config.vm.box = node[:box]
            node_config.vm.host_name = node[:hostname] + '.' + domain
            networks = node[:networks] 
            networks.each do |network|
                if network[:network_type] == "NAT"
                    node_config.vm.network "public_network",
                        :bridge => bridge
                elsif network[:network_type] == "INTERNAL"
                    node_config.vm.network "private_network", ip: network[:ip], 
                        virtualbox__intnet: network[:network_name]
                end
            end 
            node_config.vm.provider :virtualbox do |vb|
                vb.customize  [ 'modifyvm', :id, '--name', node[:hostname], '--memory', node[:memory] ]
            end
        end
    end
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'puppet/manifests'
        puppet.manifest_file = 'site.pp'
        puppet.module_path = 'puppet/modules'
    end
end

