class demoapp {
  # The apache server
  package {"httpd": ensure => installed, }->
  package {"perl-CGI": ensure => installed, }->
  package {"perl-DBD-MySQL": ensure => installed, }->
  package {"perl-Time-HiRes": ensure => installed, }->
  service {"httpd": ensure => running, }->

  # Deploy the app via git
  # Set up ssh
  file {"/root/.ssh/config":
	ensure => present,
	content => "HostName github.com
  StrictHostKeyChecking no
",
	mode => 0600,
  }->
  # Should be doing this with a role but I'm too lazy to edit my CFN template
  exec {"/usr/bin/aws s3 cp s3://naton-demos-west/celgene-event/demoapp/git-ssh-key /root/.ssh/id_rsa":
	creates => "/root/.ssh/id_rsa",
  }->
  exec {"/bin/chmod 600 /root/.ssh/id_rsa": }->
  # Install git and clone
  package {"git": ensure => installed, }->
  exec {"/usr/bin/git clone git@github.com:aimansmith/thoughts.git":
	cwd => "/opt/src",
	creates => "/opt/src/thoughts",
	require => File["/opt/src"],
  }->
  # Install the app
  exec {"/opt/src/thoughts/install.sh": }
}
