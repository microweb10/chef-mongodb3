# Install curl
package 'curl' do
  action :install
end

mms_agent_source = 'https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-manager_latest_amd64.deb'
mms_agent_file = '/root/mongodb-mms-automation-agent-manager_latest_amd64.deb'

# Download the mms automation agent manager latest
remote_file mms_agent_file do
  source mms_agent_source
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

# Install package
dpkg_package 'mongodb-mms-automation-agent-manager' do
  source mms_agent_file
  action :install
end

# Create or modify the mms agent config file
template '/etc/mongodb-mms/automation-agent.config' do
  source 'automation-agent.config.erb'
  mode 0600
  owner node['mongodb3']['user']
  group node['mongodb3']['group']
  variables(
      :config => node['mongodb3']['config']['mms']
  )
end

# Start the mms automation agent
service 'mongodb-mms-automation-agent' do
  # The service provider of MMS Agent for Ubuntu is upstart
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :stop => true
  action [ :enable, :start ]
end
