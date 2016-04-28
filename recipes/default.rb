include_recipe 'python'
include_recipe 'runit'

path = node['mimic']['path']
venv = node['mimic']['virtualenv']

%w(libffi6 libffi-dev).each do |pkg|
  package pkg do
    action :install
  end
end

# recreate virtualenv
[:delete, :create].each do |todo|
  python_virtualenv venv do
    action todo
  end
end

# install mimic
if node['mimic']['dev']
  bash 'install provided mimic' do
    code <<-CODE
      source #{venv}/bin/activate
      cd #{path}
      pip install -r requirements/production.txt
      pip install -e .
    CODE
  end
else
  python_pip 'mimic' do
    action :install
    version node['mimic']['version'] unless node['mimic']['version'].nil?
    virtualenv venv
  end
end

runit_service "mimic" do
  default_logger true
  finish true
  owner node["mimic"]["owner"]
  group node["mimic"]["group"]
  action [:enable, :start]
  retries 2
end
