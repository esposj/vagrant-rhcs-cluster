"Red Hat" Cluster using Vagrant, Virtualbox, and Centos 6
---------------------------------------------------------

The goal is to build a complete redhat cluster lab in Virtualbox, that is easy to bring up and tear down with Vagrant, and configuration management.  I plan on using Puppet first, since I am familiar with it, and then use this lab to migrate from Puppet to Chef, as a way to learn that.

There will be a minimum of 5 devices.

 * gateway.local.pvt - Firewall into the network.
 * san01.local.pvt -  This will share the 'data' directory out over iscsi.
 * server01.local.pvt - The first node.
 * server02.local.pvt - The second node.
 * client01.local.pvt - The client to test with

Finally, we will build 2 services, NFS and MySQL on server01 and server02 and use client01 to test them.

The first version of this will be bound to virtualbox, and the server hosts will need key based ssh access to the host machine.  This is because we will be using a script on the host machine to provide fencing and STONITH capabilities.

What works today:
=================

 * The gateway doesn't do anything yet.
 * yum up san01 - iscsi target backed by a small 2gb file
 * yum up server01 - iscsi initator, script runs which formats and creates an lvm volume called data and unmounts it
                - basic rchs packages
 * yum up server02 - iscsi initiator
                - basic rhcs packages

In order to use the script /usr/local/bin/stonith.sh on server01 and server02 several things need to happen

 * the host machine must allow ssh connections
 * a private key must be added to puppet/modules/baseconfig/files/id_rsa
 * an initial ssh connection must be made to cache the host-key.
 * the host must be running virtualbox, and the file puppet/modules/rhcs/files/stonith.sh should be modified to the vboxmanage binary.  It is currently configured for the default mac install of virtualbox.

As of 05/20/14, it is ready to start working through the mechanics of rhcs


san01.local.pvt
===============
 * Eth0 - NAT
 * ETH1
    Type: Internal Network
    Name: publicnet
    IP: 192.168.100.10 / 255.255.255.0
    GW: 192.168.100.1
 * ETH2 
    Type: Internal Network
    Name: storagenet 
    IP: 192.168.150.10 / 255.255.255.0

server01.local.pvt
==================
 * ETH0 - NAT
 * ETH1 
    Type: Internal Network
    Name: publicnet 
    IP: 192.168.100.30 / 255.255.255.0
 * ETH2 
    Type: Internal Network
    Name: storagenet 
    IP: 192.168.150.30 / 255.255.255.0
 * ETH3 
    Type: Internal Network
    Name: servicenet 
    IP: 192.168.200.30 / 255.255.255.0

server02.local.pvt
==================
 * ETH0 - NAT
 * ETH1
    Type: Internal Network
    Name: publicnet 
    IP: 192.168.100.40 / 255.255.255.0
 * ETH2 
    Type: Internal Network
    Name: storagenet 
    IP: 192.168.150.40 / 255.255.255.0
 * ETH3 
    Type: Internal Network
    Name: servicenet 
    IP: 192.168.200.40 / 255.255.255.0

client01.local.pvt
==================
 * ETH0 - NAT
 * ETH1
    Type: Internal Network
    Name: publicnet 
    IP: 192.168.100.40 / 255.255.255.0
 * ETH2
    Type: Internal Network
    Name: servicenet 
    IP: 192.168.200.40 / 255.255.255.0

gateway.local.pvt
=================
 * ETH0 - NAT
 * ETH1 
    Type: Internal Network
    Name: publicnet
    IP: 192.168.100.1 / 255.255.255.0

useful commands
===============
 * list Luns on the san
     sudo  tgtadm --lld iscsi --op show --mode target
 * stonith example
     sudo /usr/local/bin/stonith.sh -a server02 -o stop

