class rhcs {
    package { "cman": ensure => present, }
    package { "rgmanager": ensure => present, }
    package { "ricci": ensure => present, }
    package { "python-repoze-who-friendlyform" : ensure => present, }

    file { "/etc/motd" :
        source  => "/tmp/vagrant-puppet-3/modules-0/rhcs/files/motd",
        ensure  => present,
        replace => true,
        owner   => root,
        group   => root,    
        mode    => 0755,
    }
    file { "/usr/local/bin/stonith.sh" :
        source  => "/tmp/vagrant-puppet-3/modules-0/rhcs/files/stonith.sh",
        ensure  => present,
        replace => true,
        owner   => root,
        group   => root,    
        mode    => 0700,
    }
    exec { '/bin/echo "exclude=kernel* cman* clusterlib* rgmanager* ricci* luci* ccs* lvm* python-tw-forms python-repoze-who-friendlyform python-cement" >>/etc/yum.conf':
        unless => "/bin/grep exclude /etc/yum.conf",
    }
   
    service { "acpid" :
        ensure => stopped ,
        enable => false,
    }
    service { "ricci": 
        ensure => running,
        enable => true,
        require => Package["ricci"],
    }
}
