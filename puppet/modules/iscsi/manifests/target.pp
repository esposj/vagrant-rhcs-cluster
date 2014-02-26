class iscsi::target {
#this class will create a iscsi target using a set of fake disks

    package{ "scsi-target-utils" :
        ensure => present,
    }
    service { "tgtd" :
        enable  => true,
        ensure  => running,
        require => Package["scsi-target-utils"],
    }

    exec { "create-first-disk" :
        command     => '/bin/dd if=/dev/zero of=/fs.iscsi.disk1 bs=1M count=2048',
        creates     => '/fs.iscsi.disk1',
    }
    exec { "create-target" :
        command     => '/usr/sbin/tgtadm --lld iscsi --mode target --op new --tid=1 --targetname iqn.2014.02.pvt.local:for.all',
        unless      => '/usr/sbin/tgtadm --lld iscsi --mode target --op show | grep 2014',
        require     => Service['tgtd'],
    }
    exec { "add-first-disk" :
        command     => '/usr/sbin/tgtadm --lld iscsi --mode logicalunit --op new --tid 1 --lun 1 -b /fs.iscsi.disk1',
        unless      => '/usr/sbin/tgtadm --lld iscsi --mode target --op show | /bin/grep /fs',
        require     => Exec['create-target', 'create-first-disk'],
    }
    exec { "add-ip-access" :
        command     => '/usr/sbin/tgtadm --lld iscsi --mode target --op bind --tid 1 -I ALL',
        unless      => '/usr/sbin/tgtadm --lld iscsi --mode target --op show | /bin/grep -A2 ACL | /bin/grep ALL',
        require     => Exec['create-target'],
    }
    exec { "add-initiator-user" :
        command     => '/usr/sbin/tgtadm --lld iscsi --mode account --op new --user "consumer" --password "Longsw0rd"',
        unless      => '/usr/sbin/tgtadm --lld iscsi --mode account --op show | grep consumer',
        require     => Exec['create-target'],
    }
    exec { "bind-user-target" :
        command     => '/usr/sbin/tgtadm --lld iscsi --mode account --op bind --tid 1 --user "consumer"',
        unless      => '/usr/sbin/tgtadm --lld iscsi --mode target --op show | /bin/grep -A2 "Account information" | /bin/grep consu',
        require     => Exec['add-initiator-user', 'create-target'],
    }
}
