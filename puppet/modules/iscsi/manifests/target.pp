class iscsi::target inherits iscsi {
#this class will create a iscsi target using a set of fake disks
    file { "/etc/tgt/targets.conf" :
        source  => "/tmp/vagrant-puppet-3/modules-0/iscsi/files/targets.conf",
        ensure  => present,
        replace => true,
        require => Package["scsi-target-utils"],
    }
    exec { "create-first-disk" :
        command     => '/bin/dd if=/dev/zero of=/fs.iscsi.disk1 bs=1M count=2048',
        creates     => '/fs.iscsi.disk1',
    }
    service { "tgtd" :
        enable  => true,
        ensure  => running,
        require => [ Exec["create-first-disk"],  Package["scsi-target-utils"], File["/etc/tgt/targets.conf"] ],
    }
}
