class activemq {

    package { "apache-activemq-bin":
        ensure => latest,
        category => dev-java,
    }

    file { "/opt/apache-activemq/conf/activemq.xml":
        ensure => present,
        source => "modules/activemq/activemq.xml",
        owner => root,
        group => root,
        mode => 755,
        require => [
            Package["apache-activemq-bin"]
        ],
    }

    service { "activemq":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => [
            File["/opt/apache-activemq/conf/activemq.xml"],
            Package["apache-activemq-bin"]
        ],
    }
}
