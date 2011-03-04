class rtorrent
{
    package {
        "rtorrent":
            category => "net-p2p",
            ensure => latest;
    }

    service {
        "rtorrentd":
            enable => true,
            ensure => running,
            hasrestart => true,
            hasstatus => true,
            require => [
                Package["rtorrent"],
                File["configfile"]
            ];
    }

    file { "configfile":
        name => "/root/.rtorrent.rc",
        ensure => present,
        content => template("rtorrent.erb"),
    }
}
