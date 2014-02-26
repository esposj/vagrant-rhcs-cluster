class baseconfig {
    exec { "/usr/bin/logger 'Welcome to Vagrant'": }
    package { "vim-enhanced":
        ensure => present,
    }
}
