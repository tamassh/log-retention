define storesync::glutenvrij ( 
	$rsync_profile_name,
	$path,
	$read_only = "no",
	$hosts_allow,
){
	concat::fragment { "content for $name":
		target	=> '/etc/rsyncd.conf',
		content => template('storesync/rsync.conf.erb'),
	}
}
