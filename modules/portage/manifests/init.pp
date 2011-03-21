# These classes set up portage for use


class portage::sync {
    # Make sure we have a recent tree, and that it is known to puppet by
    # updating eix
    exec { "sync-tree":
        command => "/usr/bin/emerge --sync",
        cwd => "/root",
        require => Class["portage::config"],
    }

    exec { "eix-update":
        command => "/usr/bin/eix-update",
        cwd => "/root",
        unless => "/bin/bash -c '[[ $(date +%s)-$(stat -c %Y /var/cache/eix) -lt $(grep 'Sync completed' /var/log/emerge.log | tail -n1 | cut -f1 -d:) ]]'",
        require => [
            Exec["sync-tree"],
            Class["portage::overlay"]
        ]
    }
}

class portage::config {
    # Setup portage config files and package files

    file { "/etc/make.conf":
        ensure => present,
        content => template("portage/make.conf.erb"),
    }
    file { 
        "/etc/portage":                     ensure => directory;
        "/etc/portage/package.keywords":    ensure => directory;
        "/etc/portage/package.mask":        ensure => directory;
        "/etc/portage/package.unmask":      ensure => directory;
        "/etc/portage/package.use":         ensure => directory;
    }

    file {
        "/etc/portage/package.keywords/puppet-managed":
            ensure => present,
            content => template("portage/package.keywords/puppet-managed.erb"),
            require => File["/etc/portage/package.keywords"];
        "/etc/portage/package.mask/puppet-managed":
            ensure => present,
            content => template("portage/package.mask/puppet-managed.erb"),
            require => File["/etc/portage/package.mask"];
        "/etc/portage/package.unmask/puppet-managed":
            ensure => present,
            content => template("portage/package.unmask/puppet-managed.erb"),
            require => File["/etc/portage/package.unmask"];
        "/etc/portage/package.use/puppet-managed":
            ensure => present,
            content => template("portage/package.use/puppet-managed.erb"),
            require => File["/etc/portage/package.use"];
    }
}

class portage::overlay {
    exec {
        "install_overlay":
            command => "/usr/bin/git clone git://source.hyves.org/ramon-portage",
            cwd => "/usr/local",
            unless => "/usr/bin/test -d /usr/local/portage/.git",
            require => [
                Class["portage::config"],
                ];
        "update_overlay":
            command => "/usr/bin/git pull",
            cwd => "/usr/local/portage",
            require => [
                Exec["install_overlay"]
                ];
    }
}

class portage {
    class { "portage::overlay": stage => bootstrap }
    class { "portage::config": stage => bootstrap }
    class { "portage::sync": stage => bootstrap }
    include portage::config, portage::sync, portage::overlay
}

class { "portage": stage => bootstrap } -> Class["hostname"]
