include_recipe 'runit'

package 'python-virtualenv'
venv = node['mimic']['virtualenv']

%w(libffi6 libffi-dev).each do |pkg|
  package pkg do
    action :install
  end
end

# recreate virtualenv
bash "delete virtualenv #{venv}" do
  code "rm -rf #{venv}"
  only_if { ::File.directory?(venv) }
end

bash "create virtualenv #{venv}" do
  code "virtualenv #{venv}"
end

# install mimic
if node['mimic']['dev']
  bash 'install provided mimic' do
    code <<-CODE
      source #{venv}/bin/activate
      cd #{node['mimic']['path']}
      pip install -r requirements/production.txt
      pip install -e .
    CODE
  end
else
  mimic_version = node['mimic']['version']
  mimic_install_string = 'pip install mimic'
  mimic_install_string += "==#{mimic_version}" unless mimic_version.nil?

  bash 'install mimic' do
    code  <<-CODE
      source #{venv}/bin/activate
      #{mimic_install_string}
    CODE
  end
end

# Automat versions beyond 20.2.0 do not work with Python 2. Until we migrate to python-3 override the
# dependency installed with mimic
if node['Automat']
  automat_version = node['Automat']['version']
  automat_install_string = 'pip install Automat'
  automat_install_string += "==#{automat_version}" unless automat_version.nil?

  bash 'install Automat' do
    code <<-CODE
      source #{venv}/bin/activate
      #{automat_install_string}
    CODE
  end
end

runit_service 'mimic' do
  default_logger true
  finish true
  owner node['mimic']['owner']
  group node['mimic']['group']
  action node['mimic']['runit_actions'].map(&:to_sym)
  retries 2
  start_down node['mimic']['disabled']
end
