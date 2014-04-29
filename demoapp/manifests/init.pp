class demoapp {
  # The apache server
  package {"httpd": ensure => installed, }->
  package {"perl-CGI": ensure => installed, }->
  package {"perl-DBD-MySQL": ensure => installed, }->
  package {"perl-Time-HiRes": ensure => installed, }->
  service {"httpd": ensure => running, }->
  # Install git
  package {"git": ensure => installed, }->
  # Figure out desired branch / tag
  # Branch takes precendence
  case $demoapp_branch {
	"master": {
	  # This means we have no branch, look for a tag
	  case $demoapp_tag {
	    "none": { 
		exec {"/usr/bin/git clone -b master https://github.com/aimansmith/thoughts":
		  cwd => "/opt/src",
		  creates => "/opt/src/thoughts",
		  require => File["/opt/src"],
		}
	    }
	    /(\d|\w)/: {
		exec {"/usr/bin/git clone -b $demoapp_tag https://github.com/aimansmith/thoughts":
		  cwd => "/opt/src",
		  creates => "/opt/src/thoughts",
		  require => File["/opt/src"],
		}
	    }
	  }
	}
	default: {
	  # This should match pretty much anything
	  exec {"/usr/bin/git clone -b $demoapp_branch https://github.com/aimansmith/thoughts":
		cwd => "/opt/src",
		creates => "/opt/src/thoughts",
		require => File["/opt/src"],
	  }
	}
  }->
  exec {"/usr/bin/git pull":
	cwd => "/opt/src/thoughts",
  }->
  # Install the app
  exec {"/opt/src/thoughts/install.sh": }->
  file {"/opt/src/thoughts.properties":
	ensure => present,
	content => template('demoapp/thoughts.properties.erb'),
  }
}
