action :get_instance do
  node[:google_cloud][:instance]=JSON.parse(`/usr/local/bin/gcutil --project="#{node[:google_cloud][:project]}" getinstance #{node[:google_cloud][:instance_id]} --print_json`)
  Chef::Log.info node[:google_cloud][:instance]
end

action :get_tags do
  google_cloud_compute "get instance" do
    action :get_instance
  end
  node[:google_cloud][:compute][:tags]=node[:google_cloud][:instance]["tags"]["items"]
  node[:google_cloud][:compute][:tags_fingerprint]=node[:google_cloud][:instance]["tags"]["fingerprint"]
end

action :set_tags do
  instance=new_resource.instance
end
