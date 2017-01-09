
class storesync::install {
    user { 'create backup user':
	name 	=> "rsbackup",
	ensure 	=> 'present',
	system	=> true,
	home	=> "/bin/false",
    }->
    package { 'xinetd':
        ensure => installed,
    }->
    package { 'rsync':
        ensure => installed,
    }->
    file { '/etc/xinetd.d/rsync':
        ensure => file,
        mode   => 0755,
        owner  => "root",
        group  => "root",
        content => template('storesync/rsync.erb'),
    }
}
