class mysql::install inherits mysql 
{
    tag("mysql-install")

    package { "mysql":
        category => "dev-db",
        ensure => latest,
    }

    file { "/usr/share/mysql/mysql_system_tables_data.sql":
        content => template(
            "mysql/mysql_system_tables_data-header.sql.erb",
            "mysql/mysql_system_tables_data-vagrant.sql.erb",
            "mysql/mysql_system_tables_data-footer.sql.erb"
        ),
        require => [
            Package["mysql"]
        ],
    }

    file { "/var/log/mysql":
        ensure => directory,
        owner => mysql,
        group => mysql,
        mode => 755,
    }

    exec { "install_db":
        command => "/usr/bin/mysql_install_db --user mysql --skip-name-resolve --verbose",
        creates => "/var/lib/mysql/mysql/user.frm",
        subscribe => File["/usr/share/mysql/mysql_system_tables_data.sql"],
        require => [
            Package["mysql"],
            File["/usr/share/mysql/mysql_system_tables_data.sql"]
        ],
    }
}
