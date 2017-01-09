class storesync::service{
	service { 'rsync daemon':
		name 	=> xinetd,
		ensure	=> 'running',
		hasstatus => true,
	}
}
