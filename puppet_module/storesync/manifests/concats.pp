class storesync::concats {
        concat { '/etc/rsyncd.conf':
                ensure  => present,
                owner => 'root',
                group => 'root',
                mode  => '0644'
        }

	concat::fragment { '/etc/rsyncd.conf':
		source 	=> "puppet:///modules/storesync/preamble",
		target 	=> '/etc/rsyncd.conf',
	}
}
