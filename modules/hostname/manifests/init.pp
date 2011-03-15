class hostname {

	$myhostname="vagrant-default"
	file { 
		"/etc/conf.d/hostname":
			content => template("hostname/hostname.confd.erb"),
			ensure => present,
			notify => Service["hostname"],
			require => File["/etc/hosts"],
			;
		"/etc/hosts":
			content => template("hostname/hosts.erb"),
			ensure => present,
			;
	}

	service { "hostname":
		ensure => running,
	}
}

class { "hostname": stage => "bootstrap" } 
