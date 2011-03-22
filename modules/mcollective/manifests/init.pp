class mcollective {
    # Setup marionette collective

    package {
        "mcollective":
            category => "app-admin",
            ensure => latest,
    }

    file {
        "/etc/mcollective/client.cfg":
            ensure => present,
            content => template("mcollective/client.conf.erb"),
            require => [
                Package["mcollective"]
            ],
            ;
        "/etc/mcollective/server.cfg":
            ensure => present,
            content => template("mcollective/server.conf.erb"),
            require => [
                Package["mcollective"]
            ],
            ;
        "/etc/mcollective/facts.yaml":
            owner    => root,
            group    => root,
            mode     => 400,
            loglevel => debug,  # this is needed to avoid it being logged and reported on every run
# avoid including highly-dynamic facts as they will cause unnecessary template writes
            content  => inline_template("<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime_seconds|timestamp|free)/ }.to_yaml %>"),
            require => [
                Package["mcollective"]
                ],
            ;
    }

    service {
        "mcollectived":
            ensure => running,
            enable => true,
            hasrestart => true,
            hasstatus => true,
            require => [
                Package["mcollective"],
                File["/etc/mcollective/client.cfg"],
                File["/etc/mcollective/server.cfg"]
            ]
    }
}
