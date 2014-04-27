class demoapp {
  # The apache server
  package {"httpd": ensure => installed, }->
  package {"perl-CGI": ensure => installed, }->
  package {"perl-DBD-MySQL": ensure => installed, }->
  package {"perl-Time-HiRes": ensure => installed, }->
  service {"httpd": ensure => running, }->

  # Install git and clone
  package {"git": ensure => installed, }->
  exec {"/usr/bin/git clone https://github.com/aimansmith/thoughts":
	cwd => "/opt/src",
	creates => "/opt/src/thoughts",
	require => File["/opt/src"],
  }->
  # Install the app
  exec {"/opt/src/thoughts/install.sh": }->
  file {"/opt/src/thoughts.properties":
	ensure => present,
	content => template('demoapp/thoughts.properties.erb'),
  }
}
