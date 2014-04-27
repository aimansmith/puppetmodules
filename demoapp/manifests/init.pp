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
	    "none": { notify {"no tag given, using HEAD": } }
	    /(\d|\w)/: {
		# We have something
		$git_branchtag="$demoapp_tag"
	    }
	    default: { notify {"no tag given, using HEAD": } $git_branchtag="master" }
	  }
	}
	default: {
	  # This should match pretty much anything
	  $git_branchtag="$demoapp_branch"
	}
  }->
  exec {"/usr/bin/git clone -b $git_branchtag https://github.com/aimansmith/thoughts":
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
