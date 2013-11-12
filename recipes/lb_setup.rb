
google_cloud_lb "#{node[:google_cloud][:lb][:pool_name]}" do
  port node[:google_cloud][:lb][:port]
  tag node[:google_cloud][:lb][:tag]
  action :install
end
