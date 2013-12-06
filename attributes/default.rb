case node[:platform]
when "ubuntu","debian"
  default[:google_cloud][:python][:pkg]="python"
  default[:google_cloud][:python][:bin]="python"
when "redhat","centos"
  default[:google_cloud][:python][:pkg]="python27"
  default[:google_cloud][:python][:bin]="python2.7"
end
