# This defines a p2pclient vagrant node

class role::p2pclient inherits role
{
    package {
        "rtorrent":
            category => "net-p2p",
            ensure => present;
        "redis-py":
            category => "dev-python",
            ensure => latest;
    }

    service {
        "rtorrentd":
            enable => true,
            ensure => running,
            hasrestart => true,
            hasstatus => true,
            require => [
                Package["rtorrent"]
                ];
        }

}
