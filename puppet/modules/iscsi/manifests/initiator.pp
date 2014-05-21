class iscsi::initiator inherits iscsi {

    file { "/etc/iscsi/initiatorname.iscsi" :
        source  => "/tmp/vagrant-puppet-3/modules-0/iscsi/files/initiator.iscsi",
        ensure => present,
	replace => true,
    }

    file { "/etc/iscsi/iscsid.conf" :
        source  => "/tmp/vagrant-puppet-3/modules-0/iscsi/files/iscsid.conf",
	ensure  => present,
	replace => true,
    }
    service { "iscsi" :
        enable => true,
        ensure => running,
        require => [File["/etc/iscsi/iscsid.conf", "/etc/iscsi/initiatorname.iscsi"], Package["scsi-target-utils"],]
    } 
    service { "iscsid" :
        enable => true,
        ensure => running,
        require => [File["/etc/iscsi/iscsid.conf", "/etc/iscsi/initiatorname.iscsi"], Package["scsi-target-utils"],]
    } 
}
