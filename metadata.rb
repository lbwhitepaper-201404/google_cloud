name             'google_cloud'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures google_cloud'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "python"

recipe "google_cloud::default", "installs gcutil"


attribute "google_cloud/gcutil/auth_file_value", 
  :display_name => "Google gcutil auth file", 
  :description => "Google gcutil auth file",
  :required => "required"
  :recipes => "google_cloud::default"

attribute "google_cloud/project", 
  :display_name => "Google Cloud Project",
  :description => "Google Cloud Project",
  :required => "required",
  :recipes => "google_cloud::default"
