# -*- mode: ruby -*-
# vi: set ft=ruby :
# SEE: https://github.com/patrickdlee/vagrant-examples/blob/master/example7/Vagrantfile
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!

domain  = 'local.pvt'
gateway = '192.168.100.1'
nodes   = [
    {
        :hostname       => 'gateway',
        :box            => 'centos64', 
        :memory         => '256',
        :networks       => [
            {
                :iface_name     => 'eth0',
                :network_type   => 'NAT',
                :network_name   => '',
                :ip             => '',
                :netmask        => '',
                :gateway        => '',
            },
            {
                :iface_name     => 'eth1',
                :network_type   => 'INTERNAL',
                :network_name   => 'publicnet',
                :ip             => '192.168.100.1',
                :netmask        => '255.255.255.0',
                :gateway        => '',
            }
        ],
    },
    {
        :hostname       => 'san01',
        :box            => 'centos64',
        :memory         => '512',
        :networks       => [
            {
                :iface_name     => 'eth0',
                :network_type   => 'NAT',
                :network_name   => '',
                :ip             => '',
                :netmask        => '',
                :gateway        => '',
            },
            {
                :iface_name     => 'eth1',
                :network_type   => 'INTERNAL',
                :network_name   => 'publicnet',
                :ip             => '192.168.100.10',
                :netmask        => '255.255.255.0',
                :gateway        => '192.168.100.1',
            },
            {
                :iface_name     => 'eth2',
                :network_type   => 'INTERNAL',
                :network_name   => 'storagenet',
                :ip             => '192.168.150.10',
                :netmask        => '255.255.255.0',
                :gateway        => '',
            },
        ] ,
    }
]

Vagrant::Config.run do |config|
    nodes.each do |node|
        config.vm.define node[:hostname] do |node_config|
            node_config.vm.box = node[:box]
            node_config.vm.host_name = node[:hostname] + '.' + domain
            networks = node[:networks] 
            networks.each do |network|
                if network[:network_type] == "NAT"
                    puts "installing NAT interface"
                   config.vm.network "public_network"
                elsif network[:network_type] == "INTERNAL"
                    puts "installing private interface"
                    config.vm.network "private_network", ip: network[:ip],
                        virtualbox__intnet: network[:network_name]
                end
            end 
             
#            node_config.vm.customize [
#                'modifyvm', :id,
#                '--name', node[:hostname],
#                '--memory', node[:memory]
#            ]
        end
    end
    #config.vm.provision :puppet do |puppet|
    #    puppet.manifests_path = 'puppet/manifests'
    #    puppet.manifest_file = 'site.pp'
    #    puppet.module_path = 'puppet/modules'
    #end
end

