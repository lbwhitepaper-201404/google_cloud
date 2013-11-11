name             'google_cloud'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures google_cloud'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "python"

recipe "google_cloud::default", "installs gcutil"
recipe "google_cloud::lb_setup", "sets up google cloud lb"

#general settings
attribute "google_cloud/gcutil/auth_file_value", 
  :display_name => "Google gcutil auth file", 
  :description => "Google gcutil auth file",
  :required => "required",
  :recipes => [ "google_cloud::default" ]

attribute "google_cloud/project", 
  :display_name => "Google Cloud Project",
  :description => "Google Cloud Project",
  :required => "required",
  :recipes => [ "google_cloud::default" ]

attribute "google_cloud/region", 
  :display_name => "Google Cloud Region",
  :description => "Google Cloud Region",
  :choice => [ "us-central1", "us-central2", "europe-west1" ],
  :required => "required",
  :recipes => [ "google_cloud::lb_setup" ]

#lb settings
attribute "google_cloud/lb/pool_name",
  :display_name => "Google LB Pool Name",
  :description => "Google LB Pool Name",
  :required => "required",
  :recipes => [ "google_cloud::lb_setup" ]
