include_recipe "python"
include_recipe "runit"
include_recipe "git"

path = node["mimic"]["path"]
venv = node["mimic"]["virtualenv"]
is_dev = node["mimic"]["dev"]

# I dont like this
%w(libffi6 libffi-dev).each do |pkg|
  package pkg do
    action :install
  end
end

unless is_dev
  # fresh checkout
  directory path do
    action :delete
    recursive true
  end

  git path do
    repository node["mimic"]["github"]
    revision node["mimic"]["revision"] or "master"
    action :export
  end
end

# recreate virtualenv
[:delete, :create].each do |todo|
  python_virtualenv venv do
    action todo
  end
end

# install mimic
python_pip path do
  action :install
  virtualenv venv
  if is_dev
    options "-e"
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
