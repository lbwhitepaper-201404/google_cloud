
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

package "coreutils" do
  action :install
end

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

execute "export CLOUDSDK_PYTHON=#{node[:google_cloud][:python][:bin]}; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; #{node[:google_cloud][:python][:bin]} /opt/google-cloud-sdk/bin/bootstrapping/install.py"

template "/etc/profile.d/google_cloud.sh" do
  source "google_cloud.sh.erb"
  owner "root"
  group "root"
  mode "0777"
  variables( :python => node[:google_cloud][:python][:bin] )
  action :create
end

directory ::File.join(node[:google_cloud][:auth][:directory],'gcloud') do
  recursive true
  mode 0755
  action :create
end

#base64 encoded authentication file - uses a dash credential
bash "creating authenticated google dir" do
  code <<-EOH
  echo #{node[:google_cloud][:auth][:credential_file]} > /tmp/creds.base
  base64 -d /tmp/creds.base > /tmp/creds.tar
  tar -xvf /tmp/creds.tar -C #{node[:google_cloud][:auth][:directory]}
  EOH
  flags "-ex"
end

cookbook_file "/opt/google-cloud-sdk/bin/cloudsdk_python" do
  source "cloudsdk_python"
  owner "root"
  group "root"
  mode "0777"
  action :create
end

bash "update python" do
  cwd "/opt/google-cloud-sdk/bin"
  code <<-EOF
    sed -i -e 's/python/cloudsdk_python/1' gcutil
    sed -i -e 's/python/cloudsdk_python/1' gsutil
  EOF
end

execute ". /etc/profile.d/google_cloud.sh; /opt/google-cloud-sdk/bin/gcloud config set account #{node[:google_cloud][:auth][:account]}"
execute ". /etc/profile.d/google_cloud.sh; /opt/google-cloud-sdk/bin/gcloud config set project #{node[:google_cloud][:project]}"
