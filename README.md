"Red Hat" Cluster using Vagrant, Virtualbox, and Centos 6
---------------------------------------------------------

The goal is to build a complete redhat cluster lab in Virtualbox, that is easy to bring up and tear down with Vagrant, and configuration management.  I plan on using Puppet first, since I am familiar with it, and then use this lab to migrate from Puppet to Chef, as a way to learn that.

There will be a minimum of 5 devices.

 * gateway.local.pvt - Firewall into the network.
 * san01.local.pvt -  This will share the 'data' directory out over iscsi.
 * server01.local.pvt - The first node.
 * server02.local.pvt - The second node.
 * client01.local.pvt - The client to test with

There will possibly be a 5th node in the future to allow us to use NAT networking for the 'public' interface into the environment.  For version 1, I will be using 3 networks for each device:


Finally, we will build 2 services, NFS and MySQL on server01 and server02 and use client01 to test them.

The first version of this will be bound to virtualbox, and the server hosts will need key based ssh access to the host machine.  This is because we will be using a script on the host machine to provide fencing and STONITH capabilities.

In the future, it would be worth investigating whether or not this VagrantFile can be ported to the Rackspace Cloud provider.

gateway.local.pvt
=================
 * ETH0 - NAT
 * ETH1 
    Type: Internal Network
    Name: publicnet
    IP: 192.168.100.1 / 255.255.255.0

san01.local.pvt
===============
 * ETH0 
    Type: Internal Network
    Name: publicnet
    IP: 192.168.100.10 / 255.255.255.0
    GW: 192.168.100.1
 * ETH1 
    Type: Internal Network
    Name: storagenet 
    IP: 192.168.150.10 / 255.255.255.0

server01.local.pvt
==================
 * ETH0 
    Type: Internal Network
    Name: publicnet 
    IP: 192.168.100.30 / 255.255.255.0
 * ETH1 
    Type: Internal Network
    Name: storagenet 
    IP: 192.168.150.30 / 255.255.255.0
 * ETH2 
    Type: Internal Network
    Name: servicenet 
    IP: 192.168.200.30 / 255.255.255.0

server02.local.pvt
==================
 * ETH0 
    Type: Internal Network
    Name: publicnet 
    IP: 192.168.100.40 / 255.255.255.0
 * ETH1 
    Type: Internal Network
    Name: storagenet 
    IP: 192.168.150.40 / 255.255.255.0
 * ETH2 
    Type: Internal Network
    Name: servicenet 
    IP: 192.168.200.40 / 255.255.255.0

client01.local.pvt
==================
 * ETH0 
    Type: Internal Network
    Name: publicnet 
    IP: 192.168.100.40 / 255.255.255.0
 * ETH1 
    Type: Internal Network
    Name: servicenet 
    IP: 192.168.200.40 / 255.255.255.0

