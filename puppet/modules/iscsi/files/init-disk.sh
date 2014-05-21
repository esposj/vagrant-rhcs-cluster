#!/bin/bash
iscsiadm --mode discovery -t sendtargets --portal 192.168.150.10
iscsiadm --mode node --targetname iqn.2014.02.pvt.local:san.target01 --portal 192.168.150.10 --login
parted /dev/sdb --script mklabel msdos
parted /dev/sdb --script -- mkpart primary 0 -1
parted /dev/sdb --script -- set 1 lvm on
parted /dev/sdb --script print
pvcreate /dev/sdb1
vgcreate /dev/sdb1 vg-san
vgcreate vg-san /dev/sdb1
vcereate -n data -l 100%FREE vg-san
lvcreate -n data -l 100%FREE vg-san
lvdisplay
mkfs.ext4 /dev/mapper/vg--san-data
mkdir /data
mount -t ext4 /dev/mapper/vg--san-data /data
touch /data/test-from-init
umount /data
touch /root/.disk-is-inititalized

