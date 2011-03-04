# This defines a tracker vagrant node

class role::tracker inherits role
{
    package {
        "flask":
            category => "dev-python",
            ensure => latest;
        "redis-py":
            category => "dev-python",
            ensure => latest;
        "redis":
            category => "dev-db",
            ensure => latest;
        "mktorrent":
            category => "net-p2p",
            ensure => latest;
    }

    service {
        "redis":
            enable => true,
            ensure => running,
            hasrestart => true,
            hasstatus => true,
            require => [
                Package["redis"]
                ];
        }
    include rtorrent
}
