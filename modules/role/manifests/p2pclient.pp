# This defines a p2pclient vagrant node

class role::p2pclient inherits role
{

    include rtorrent
    package {
        "redis-py":
            category => "dev-python",
            ensure => latest;
    }
}
