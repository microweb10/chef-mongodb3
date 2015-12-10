# Add the MongoDB 3.0 Package repository

apt_repository 'mongodb' do
  uri node['mongodb3']['package']['repo']['url']
  distribution "trusty/mongodb-org/3.0"
  components node['mongodb3']['package']['repo']['apt']['components']
  keyserver node['mongodb3']['package']['repo']['apt']['keyserver']
  key node['mongodb3']['package']['repo']['apt']['key']
  action :add
end
include_recipe 'apt'

