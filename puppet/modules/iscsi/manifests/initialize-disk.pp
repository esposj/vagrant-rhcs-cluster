class iscsi::initialize-disk inherits iscsi::initiator {
    file { "/root/init-disk.sh" :
        source  => "/tmp/vagrant-puppet-3/modules-0/iscsi/files/init-disk.sh", 
        ensure  => present,
        mode    => 0750,
        owner   => root,
        group    => root, 
    }

    exec { "/root/init-disk.sh" :
        unless => "/sbin/lvdisplay |grep '/dev/vg-san/data' && /bin/ls /root/.disk-is-inititalized" ,
        require => [File['/root/init-disk.sh'], Service['iscsid'], Package["parted"] ],
    }
}
