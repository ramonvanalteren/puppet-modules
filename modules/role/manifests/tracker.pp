# This defines a tracker vagrant node

class role::tracker inherits role
{
    package {
        "rtorrent":
            category => "net-p2p",
            ensure => present;
        "flask":
            category => "dev-python",
            ensure => latest;
        "redis-py":
            category => "dev-python",
            ensure => latest;
        "redis":
            category => "dev-db",
            ensure => latest;
    }

    service { "redis":
        enable => true,
        ensure => running,
        hasrestart => true,
        hasstatus => true,
        require => [
            Package["redis"]
            ]
        }
}
