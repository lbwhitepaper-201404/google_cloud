
# Cookbook Name:: google_cloud
# Recipe:: default
#
# Copyright 2013, RightScale Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


package node[:google_cloud][:python][:pkg] do
  action :install
end

remote_file "/opt/google-cloud-sdk.tar.gz" do
  source "https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "tar -xzf /opt/google-cloud-sdk.tar.gz -C /opt"

execute "CLOUDSDK_CORE_DISABLE_PROMPTS=1 #{node[:google_cloud][:python][:bin]} /opt/google-cloud-sdk/bin/bootstrapping/install.py"

template "/etc/profile.d/google_cloud.sh" do
  source "google_cloud.sh.erb"
  owner "root"
  group "root"
  mode "0777"
  action :create
end

directory "/root/.config/gcloud" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/root/.config/gcloud/credentials" do
  source "gcutil_auth.erb"
  owner "root"
  group "root"
  mode "0600"
  variables( :auth_value => node[:google_cloud][:gcutil][:auth_file_value] )
  action :create
end

template "/opt/google-cloud-sdk/bin/gcloud" do
  source "gcloud.erb"
  owner "root"
  group "root"
  variables( :python => node[:google_cloud][:python][:bin] )
  mode "0777"
  action :create
end

bash "set python version" do 
  cwd "/opt/google-cloud-sdk/bin/"
  code <<-EOF
    sed -i -e 's/python/python2.7/1' gsutil
    sed -i -e 's/python/python2.7/1' gcutil
  EOF
  only_if { node[:google_cloud][:python][:bin] == "/usr/bin/python2.7" }
end

execute "gcloud config set project #{node[:google_cloud][:project]}"
