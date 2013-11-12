#
# Cookbook Name:: google_cloud
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements
# such as a RightScale Master Subscription Agreement.

# @resource lb

# Installs the Creates Google Load Balancer, can checks for GCUTIL"
action :install do
  require 'json'

  pool_name=new_resource.pool_name
  port=new_resource.port
  tag=new_resource.tag

  Chef::Log.info "creating firewall rule"
  execute "/usr/local/bin/gcutil addfirewall #{pool_name}-firewall --target_tags=#{tag} --allowed=tcp:#{port}"

  Chef::Log.info "Creating health check"
  execute "/usr/local/bin/gcutil --service_version=\"v1beta16\" addhttphealthcheck \"health-check-#{pool_name}\""

  Chef::Log.info "creating lb pool" 
  execute "/usr/local/bin/gcutil --service_version=\"v1beta16\" addtargetpool \"#{pool_name}\" --region=\"#{node[:google_cloud][:region]}\" --health_checks=\"health-check-#{pool_name}\""
  
  Chef::Log.info "creating ip address"
  parsed_ip=JSON.parse(`/usr/local/bin/gcutil reserveaddress "#{pool_name}" --region=us-central1 --print_json`)["items"][1]["address"]
  
  Chef::Log.info "adding forwarding rule"
  execute "/usr/local/bin/gcutil --service_version=\"v1beta16\" addforwardingrule \"forwarding-rule-#{pool_name}\" --region=\"#{node[:google_cloud][:region]}\" --ip=\"#{parsed_ip}\" --target=\"#{pool_name}\""
  
end

# Attaches an application server to Elastic Load Balancer
action :attach do
  
  service_lb_name=new_resource.service_lb_name
  if new_resource.tag.nil?
    lb_fw_tag=node[:google][:lb][:tag]
  else
    lb_fw_tag=new_resource.tag
  end

  Chef::Log.info "  Attaching #{node[:google_cloud][:instance_id]} to" +
    " #{service_lb_name}"

  # Opens the backend_port.
  # See cookbooks/sys_firewall/providers/default.rb for the "update" action.
  sys_firewall "Open backend_port to allow ELB to connect" do
    port new_resource.backend_port
    enable true
    ip_addr "any"
    action :update
  end
  #opening google firewall port
  instance=JSON.parse(`/usr/local/bin/gcutil --project="#{node[:google_cloud][:project]}" getinstance #{node[:google_cloud][:instance_id]} --print_json`)
  fingerprint=instance["tags"]["fingerprint"]
  tags=instance["tags"]["items"]
  tags<<lb_fw_tag
  execute "/usr/local/bin/gcutil --project=\"#{node[:google_cloud][:project]}\" setinstancetags #{node[:google_cloud][:instance_id]} --tags #{tags.join(",")} --fingerprint #{fingerprint}"

  #add a instance to resource pool
  execute "/usr/local/bin/gcutil --project=#{node[:google_cloud][:project]} addtargetpoolinstance #{service_lb_name} --instances=#{node[:google_cloud][:zone_id]}/#{node[:google_cloud][:instance_id]} --region=#{node[:google_cloud][:region]}"
  
end

# Sends an attach request from an application server to an Elastic Load Balancer
action :attach_request do

  Chef::Log.info "  Attach request for #{node[:google_cloud][:instance_id]}"

  # Calls the "attach" action
  lb "Attaching to GCE-LB" do
    provider "google_cloud_lb"
    backend_port new_resource.backend_port
    service_lb_name new_resource.service_lb_name
    service_account_id new_resource.service_account_id
    service_account_secret new_resource.service_account_secret
    action :attach
  end

end

# Detaches an application server from the Elastic Load Balancer
action :detach do

  if new_resource.tag.nil?
    lb_fw_tag=node[:google][:lb][:tag]
  else
    lb_fw_tag=new_resource.tag
  end

  Chef::Log.info "  Detaching #{node[:google_cloud][:instance_id]} from" +
    " #{new_resource.service_lb_name}"

  #add code here
   execute "/usr/local/bin/gcutil --project=#{node[:google_cloud][:project]} removetargetpoolinstance #{service_lb_name} --instances=#{node[:google_cloud][:zone_id]}/#{node[:google_cloud][:instance_id]} --region=#{node[:google_cloud][:region]}"

  # See cookbooks/sys_firewall/providers/default.rb for the "update" action.
  sys_firewall "Close backend_port allowing ELB to connect" do
    port new_resource.backend_port
    enable false
    ip_addr "any"
    action :update
  end

  #closing google firewall port
  instance=JSON.parse(`/usr/local/bin/gcutil --project="#{node[:google_cloud][:project]}" getinstance #{node[:google_cloud][:instance_id]} --print_json`)
  fingerprint=instance["tags"]["fingerprint"]
  tags=instance["tags"]["items"]
  tags.delete(lb_fw_tag)
  execute "/usr/local/bin/gcutil --project=\"#{node[:google_cloud][:project]}\" setinstancetags #{node[:google_cloud][:instance_id]} --tags #{tags.join(",")} --fingerprint #{fingerprint}"
  #
end

# Sends a detach request from an application server to an Elastic Load Balancer
action :detach_request do

  Chef::Log.info "  Detach request for #{node[:google_cloud][:instance_id]}"

  # Calls the "detach" action
  lb "Detaching from GCE-LB" do
    provider "google_cloud_lb"
    backend_port new_resource.backend_port
    service_lb_name new_resource.service_lb_name
    service_account_id new_resource.service_account_id
    service_account_secret new_resource.service_account_secret
    action :detach
  end

end

# Installs and configures collectd plugins for the server. Not applicable.
action :setup_monitoring do
  Chef::Log.info "  Setup monitoring does not apply to GCE-LB"
end

# Restarts the Elastic Load Balancer service. Not applicable.
action :restart do
  Chef::Log.info "  Restart does not apply to GCE-LB"
end
