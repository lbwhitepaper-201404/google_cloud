default[:google_cloud][:auth][:directory]=::File.join(ENV['HOME'],'.config')
case node[:platform]
when "ubuntu","debian"
  default[:google_cloud][:python][:pkg]="python"
  default[:google_cloud][:python][:bin]="/usr/bin/python"
when "redhat","centos"
  default[:google_cloud][:python][:pkg]="python27"
  default[:google_cloud][:python][:bin]="/usr/bin/python2.7"
end
