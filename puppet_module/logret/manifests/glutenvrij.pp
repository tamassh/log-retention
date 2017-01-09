define logret::glutenvrij (
		$eligible_to_del_local,
		$locations_to_sync,
		$days_to_keep_local,
		$log_path_formatted,
		$rsync_address,
		$rsync_profile_name,
		$rsync_retry_interval,
		$rsync_max_retry ) {

		file { "/etc/glutenvrij/config/${title}.conf":
		        ensure       =>  $ensure,
		        owner        =>  "root",
		        group        =>  "root",
		        mode         =>  0644,
		        content      =>  template("logret/retention.conf.erb"),
		}
}
