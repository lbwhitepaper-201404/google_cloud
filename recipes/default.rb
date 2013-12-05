
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

execute "tar -xvzf /opt/google-cloud-sdk.tar.gz"

execute "CLOUDSDK_CORE_DISABLE_PROMPTS=1 #{node[:google_cloud][:python][:bin]} /opt/google-cloud-sdk/bin/bootstrapping/install.py"

template "/etc/profile.d/google_cloud.sh" do
  source "google_cloud.sh.erb"
  owner "root"
  group "root"
  mode "0777"
  variables( :version => node[:google_cloud][:gcutil][:version] )
  action :create
end

template "/root/.gcutil_auth" do
  source "gcutil_auth.erb"
  owner "root"
  group "root"
  mode "0600"
  variables( :auth_value => node[:google_cloud][:gcutil][:auth_file_value] )
  action :create
end

