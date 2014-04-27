class dbload {
  package {"mysql": ensure => installed, }->
  package {"mysql-server": ensure => installed, }->
  service {"mysqld": ensure => running, }->
  # Do this with a script
  file {"/usr/local/bin/load_latest_db_backup.sh":
	ensure => present,
	mode => 0755,
	content => template('dbload/load_latest_db_backup.sh.erb'),
  }->
  exec {"/usr/local/bin/load_latest_db_backup.sh": }
}
