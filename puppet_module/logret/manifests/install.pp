
class logret::install {
    file { "/usr/local/glutenvrij":
        ensure       =>  directory,
        owner        =>  "root",
        group        =>  "root",
        mode         =>  0755,
    }->
    file { '/usr/local/glutenvrij/functions':
        ensure => file,
        mode   => 0644,
        owner  => "root",
        group  => "root",
        source => "puppet:///modules/logret/functions",
    }->
    file { "/var/log/glutenvrij":
        ensure       =>  directory,
        owner        =>  "root",
        group        =>  "root",
        mode         =>  0755,
    }
    file { '/usr/local/glutenvrij/retention.sh':
        ensure => file,
        mode   => 0755,
        owner  => "root",
        group  => "root",
        source => "puppet:///modules/logret/retention.sh",
    }->
    file { '/usr/local/bin/check_glutenvrij':
        ensure => file,
        mode   => 0755,
        owner  => "root",
        group  => "root",
        source => "puppet:///modules/logret/check_glutenvrij",
    }->
	cron { glutenvrij:
	command => "/usr/local/glutenvrij/retention.sh",
	user    => root,
	hour    => 3,
	minute  => 14,
    }


    package { 'mktemp':
        ensure => installed,
    }

    package { 'rsync':
        ensure => installed,
    }
}
