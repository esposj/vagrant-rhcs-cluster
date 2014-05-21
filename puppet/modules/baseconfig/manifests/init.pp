class baseconfig {
    exec { "/usr/bin/logger 'Welcome to Vagrant'": }
    package { "vim-enhanced":
        ensure => present,
    }
    package { "parted":
        ensure => present,
    }
    file { "/root/.ssh" : 
        ensure  => 'directory',
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
    }
    file { "/root/.ssh/id_rsa" :
        ensure  => present,
        recurse => true,
        replace => false,
        source  => "/tmp/vagrant-puppet-3/modules-0/baseconfig/files/id_rsa",
        require => File['/root/.ssh'],
        owner   => root,
        group   => root,
        mode    => 0600,
    }
    file { "/etc/hosts" :
        ensure  => present,
        replace => true,
        source  => "/tmp/vagrant-puppet-3/modules-0/baseconfig/files/hosts",
        owner   => root,
        group   => root,
        mode    => 0755,
    }
    service { "iptables" :
	ensure => stopped,
	enable => false,
    }

}
