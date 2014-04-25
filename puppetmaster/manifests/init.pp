class puppetmaster {
  # Set up ssh
  file {"/root/.ssh/config":
        ensure => present,
        content => "HostName github.com
  StrictHostKeyChecking no
",
        mode => 0600,
  }->
  # Should be doing this with a role but I'm too lazy to edit my CFN template
  exec {"/usr/bin/aws s3 cp s3://naton-demos-west/celgene-event/puppetmaster/git-ssh-key /root/.ssh/id_rsa":
        creates => "/root/.ssh/id_rsa",
  }->
  exec {"/bin/chmod 600 /root/.ssh/id_rsa": }->
  package {"git": ensure => installed, }->
  exec {"/usr/bin/git clone git@github.com:aimansmith/puppetmodules":
	cwd => "/opt/src",
	require => File["/opt/src"],
	creates => "/opt/src/puppetmodules",
  }
}
