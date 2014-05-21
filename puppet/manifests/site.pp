# create a new run stage to ensure certain modules are included first
stage { 'pre':
    before => Stage['main']
}

# add the baseconfig module to the new 'pre' run stage
class { 'baseconfig':
    stage => 'pre'
}

# set defaults for file ownership/permissions
File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
}

# all boxes get the base config
include baseconfig

node gateway{}
node san01{
    include iscsi::target
}
node server01{
    include iscsi::initiator
    include iscsi::initialize-disk
    include rhcs
    package { "luci": ensure => present }
}
node server02{
    include iscsi::initiator
}
node client01{}
