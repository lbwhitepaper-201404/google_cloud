
google_cloud_lb "#{node[:google_cloud][:lb][:pool_name]}" do
  action :install
end
