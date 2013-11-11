
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

remote_file "/tmp/gcutil-#{node[:google_cloud][:gcutil][:version]}.tar.gz" do
  source "https://google-compute-engine-tools.googlecode.com/files/gcutil-#{node[:google_cloud][:gcutil][:version]}.tar.gz"
  owner "root"
  group "root"
  mode "0644"
  checksum node[:google_cloud][:gcutil][:sha]
  action :create
end

execute "tar -xzpf /tmp/gcutil-#{node[:google_cloud][:gcutil][:version]}.tar.gz -C /usr/local/share"

template "/etc/profile.d/google_cloud.sh" do
  source "google_cloud.sh.erb"
  owner "root"
  group "root"
  mode "0777"
  variables( :version => node[:google_cloud][:gcutil][:version] )
  action :create
end

link "/usr/local/bin/gcutil" do
  to "/usr/local/share/gcutil-#{node[:google_cloud][:gcutil][:version]}/gcutil"
  link_type :symbolic
  action :create
end

template "/root/.gcutil_auth" do
  source "google_auth.erb"
  owner "root"
  group "root"
  mode "0600"
  variables( :auth_value => node[:google_cloud][:gcutil][:auth_file_value] )
  action :create
end

execute "/usr/local/bin/gcutil getproject --project=#{node[:google_cloud][:project]} --cache_flag_values"

gem "json" do
  action :install
end
