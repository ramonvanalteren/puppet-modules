# vi: expandtab ts=4 sw=4 ai

class mysql
{
    tag("mysql")

    class { "mysql::install": stage => bootstrap } -> Class["portage"]
    class { "mysql::config": stage=> main }

    service { "mysql":
        enable => true,
        ensure => running,
        hasrestart => true,
        hasstatus => true,
        require => [
            Class["mysql::install"],
            Class["mysql::config"]
        ],
    }
}

class { "mysql": stage => main }
