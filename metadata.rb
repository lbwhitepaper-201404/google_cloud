name             'google_cloud'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures google_cloud'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.9'

depends "python"
depends "sys_firewall"

recipe "google_cloud::default", "installs google_cloud_sdk"
recipe "google_cloud::gcloud_components_update", "updates the components"
recipe "google_cloud::lb_setup", "sets up google cloud lb"
recipe "google_cloud::lb_do_attach", "attaches to lb"
recipe "google_cloud::lb_do_detach", "detaches from lb"

#general settings
attribute "google_cloud/auth/credential_file", 
  :display_name => "Google cred file", 
  :description => "Google cred auth file",
  :required => "required",
  :recipes => [ "google_cloud::default" ]

attribute "google_cloud/auth/account",
  :display_name => "Google Auth Account",
  :description => "Google Auth Account Name",
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
  :required => "required"

attribute "google_cloud/instance_id",
  :display_name => "Google Cloud Instance ID",
  :description => "Google Cloud Instance ID",
  :required => "optional",
  :recipes => [ "google_cloud::default" ]

#lb settings
attribute "google_cloud/lb/pool_name",
  :display_name => "Google LB Pool Name",
  :description => "Google LB Pool Name",
  :required => "required",
  :recipes => [ "google_cloud::lb_setup", "google_cloud::lb_do_attach", "google_cloud::lb_do_detach" ]

attribute "google_cloud/lb/port",
  :display_name => "Google LB Port Number", 
  :description => "Google LB Port Number",
  :required => "optional",
  :default => "80",
  :recipes => [ "google_cloud::lb_setup" ]

attribute "google_cloud/lb/tag",
  :display_name => "Google LB Firewall Tag",
  :description => "Google LB Firewall Tag",
  :required => "optional",
  :default => "www",
  :recipes => [ "google_cloud::lb_setup" ]

attribute "google_cloud/lb/ip", 
  :display_name => "Google LB IP",
  :description => "Google Cloud Static IP",
  :required => "required",
  :recipes => [  "google_cloud::lb_do_attach", "google_cloud::lb_do_detach" ]
