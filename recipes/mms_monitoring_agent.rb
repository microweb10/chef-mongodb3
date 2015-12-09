# Install curl
package 'curl' do
  action :install
end

# Set variables by platform
mms_agent_source = 'https://cloud.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent_latest_amd64.deb'
mms_agent_file = '/root/mongodb-mms-monitoring-agent_latest_amd64.deb'

# Download the mms automation agent manager latest
remote_file mms_agent_file do
  source mms_agent_source
  action :create
end

# Install package
dpkg_package 'mongodb-mms-monitoring-agent' do
  source mms_agent_file
  action :install
end

# Create or modify the mms agent config file
template '/etc/mongodb-mms/monitoring-agent.config' do
  source 'monitoring-agent.config.erb'
  mode 0600
  owner 'mongodb-mms-agent'
  group 'mongodb-mms-agent'
  variables(
      :config => node['mongodb3']['config']['mms']
  )
end

# Start the mms automation agent
service 'mongodb-mms-monitoring-agent' do
  # The service provider of MMS Agent for Ubuntu is upstart
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :stop => true
  action [ :enable, :start ]
end
