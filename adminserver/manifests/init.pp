class adminserver {
  package {"mysql":  ensure => installed, }->
  file {"/usr/local/bin/backup_demoapp_db.sh":
	mode => 0755,
	content => template('adminserver/backup_demoapp_db.sh.erb'),
	replace => yes,
	ensure => present,
  }
}
