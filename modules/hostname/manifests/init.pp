class { "hostname": stage => "bootstrap" } 

class hostname {
	class { "hostname::setup": stage => "bootstrap" }
	include hostname::setup
}

class hostname::setup {

	$thishostname = $myhostname ? {
		default => "vagrant-default"
		}

	file { 
		"/etc/conf.d/hostname":
			content => template("hostname/hostname.confd.erb"),
			ensure => present,
			notify => Exec["hostname-refresh"],
			require => File["/etc/hosts"],
			;
		"/etc/hosts":
			content => template("hostname/hosts.erb"),
			ensure => present,
			;
	}

	exec { "hostname-refresh":
		command => "/bin/bash -c '/etc/init.d/hostname restart'",
		require => [
			File["/etc/conf.d/hostname"],
			File["/etc/hosts"]
		],
	}
}

